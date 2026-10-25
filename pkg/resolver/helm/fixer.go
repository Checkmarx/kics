package helm

import (
	"fmt"
	"regexp"
	"sort"
	"strconv"
	"strings"

	"helm.sh/helm/v3/pkg/chartutil"
)

// This file ports the helm "fixer" algorithm into the KICS helm resolver.
//
// When a chart fails to render, KICS normally drops it and scans nothing. The
// fixer instead classifies the render error and injects a placeholder value
// (a `--set` override, or a `--kube-version` for kubeVersion constraints), then
// re-renders, looping until the chart renders or no further progress is made.
// This recovers charts that fail only because a required value was left unset,
// a nil map was dereferenced, or a value had the wrong type.
//
// The fixer only ATTEMPTS errors it can plausibly repair by value injection.
// Two classes are inherently non-fixable and are deliberately DOCUMENTED here
// and skipped (see isUnparseableYAML / isUnsupportedBuiltin): malformed YAML the
// chart cannot even parse, and nil-pointers on Helm built-ins (.Release,
// .Capabilities, ...) whose data comes from Helm itself, not from values.

const (
	kindNilPointer    = "nil_pointer"
	kindRequiredValue = "required_value"
	kindTypeMismatch  = "type_mismatch"
	kindKubeVersion   = "kube_version"
	kicsPlaceholder   = "kics-placeholder"
	maxFixIterations  = 50
)

var (
	// atValuesRe captures the offending value path from a Go-template error's
	// "at <.Values.x.y ...>" clause (nil-pointer and wrong-type errors). The
	// optional "$" handles templates that reference the root context explicitly,
	// e.g. "at <$.Values.global.security>" — $ is Go-template's root data ref.
	atValuesRe = regexp.MustCompile(`at <\$?(\.Values\.[^ |>]+)`)

	// valuesPathRe matches an explicit ".Values.x.y" path anywhere in a message.
	valuesPathRe = regexp.MustCompile(`\.Values\.([A-Za-z_]\w*(?:\.[A-Za-z_]\w*)*)`)

	// kubeVersionReqRe captures the constraint from a kubeVersion incompatibility,
	// e.g. "chart requires kubeVersion: >= 1.30.0 < 1.34.0 which is incompatible ...".
	kubeVersionReqRe = regexp.MustCompile(`requires kubeVersion:\s*(.+?)\s+which is incompatible`)

	// clauseRe matches one "<op> <version>" clause of a semver constraint;
	// the operator is optional (a bare version means an exact match).
	clauseRe = regexp.MustCompile(`(>=|<=|==|!=|>|<|=)?\s*v?(\d+)\.(\d+)(?:\.(\d+))?(?:-([0-9A-Za-z.-]+))?`)

	// requiredValueForRe matches charts that demand a specific sub-field of a
	// values entry, e.g. the acuvity mcp-server secrets pattern:
	//   required value for secrets.FOO either as .value or .valueFrom.name and .valueFrom.key
	// The chart reads <entry>.value, so the placeholder must be injected at
	// "<path>.value" rather than at "<path>" itself (handled in parseError).
	requiredValueForRe = regexp.MustCompile(`required value for ([A-Za-z_][\w.-]*) either as`)

	// requiredPathRes recover a value path embedded in a custom required/fail
	// message, tried in priority order. All but the last require a dotted
	// (>=2 segment) path so we don't guess from a bare English word. Path
	// segments allow hyphens so subchart aliases (e.g. op-geth.secrets.x) match.
	requiredPathRes = []*regexp.Regexp{
		regexp.MustCompile(`(?i)missing required value\s+\.?([A-Za-z_][\w.-]*)`),
		regexp.MustCompile(`(?i)please (?:define|specify|provide|set)\s+\.?([A-Za-z_][\w-]*(?:\.[A-Za-z_][\w-]*)+)`),
		regexp.MustCompile(`(?i)--set(?:-string|-file)?\s+\.?([A-Za-z_][\w-]*(?:\.[A-Za-z_][\w-]*)+)\s*=`),
		regexp.MustCompile(`\.?([A-Za-z_][\w-]*(?:\.[A-Za-z_][\w-]*)+)\s+is\s+(?:required|mandatory)`),
		// Dotted path immediately (or one word, e.g. "entry") before a bare
		// "required"/"mandatory", covering "x.y required!" / "x.y entry required".
		regexp.MustCompile(`\.?([A-Za-z_][\w-]*(?:\.[A-Za-z_][\w-]*)+)(?:\s+\w+)?\s+(?:required|mandatory)\b`),
		// "<path> must be set/provided/specified/defined".
		regexp.MustCompile(`(?i)\.?([A-Za-z_][\w-]*(?:\.[A-Za-z_][\w-]*)+)\s+must\s+be\s+(?:set|provided|specified|defined)`),
		// A dotted path wrapped in quotes, e.g. value 'sysdig.secureAPIToken' is required.
		regexp.MustCompile(`['"]\.?([A-Za-z_][\w-]*(?:\.[A-Za-z_][\w-]*)+)['"]`),
		regexp.MustCompile(`\.([A-Za-z_][\w-]*)\s+is\s+(?:required|mandatory)`),
	}

	// requiredMarkers identify a custom "this value must be provided" failure
	// (the Helm `required` builtin or a hand-written `fail` guard).
	requiredMarkers = []string{
		"error calling required",
		"required",
		"mandatory",
		"please define",
		"please specify",
		"please provide",
		"missing required value",
		"must be set",
		"must be provided",
		"must specify",
		"must provide",
	}

	// unparseableYAMLMarkers identify a chart/values file Helm cannot parse at all
	// (malformed YAML or a JSON unmarshal mismatch). No value injection can fix
	// these, so the fix loop documents and skips them as a non-fixable class.
	unparseableYAMLMarkers = []string{
		"cannot unmarshal",
		"error unmarshaling json",
		"error converting yaml to json",
		"error reading yaml document",
	}

	// builtinNilRe matches a nil-pointer error whose at-clause targets a Helm
	// built-in object that cannot be set via --set: .Release, .Capabilities, .Chart,
	// .Template, .Files (optional "$" root ref). The classic case is .Release.Time,
	// removed in Helm 3 — charts written for Helm 2 hit a nil pointer that no value
	// injection can repair.
	builtinNilRe = regexp.MustCompile(`at <\$?\.(Release|Capabilities|Chart|Template|Files)\.`)

	// missingDependencyMarkers identify a render that failed only because the
	// chart's declared subcharts have not been vendored into charts/ yet. The fix
	// loop answers this class with a single `helm dependency build` (see
	// updateDependencies); these markers recognise the error still standing
	// afterwards, so the loop stops instead of spinning.
	missingDependencyMarkers = []string{
		"missing in charts/ directory",
		"an error occurred while checking for chart dependencies",
	}
)

// isUnparseableYAML reports whether errStr is a malformed-YAML / unmarshal
// failure — an inherently non-fixable error (the chart can't be parsed).
// Documented and skipped by the fix loop.
func isUnparseableYAML(errStr string) bool {
	low := strings.ToLower(errStr)
	for _, m := range unparseableYAMLMarkers {
		if strings.Contains(low, m) {
			return true
		}
	}
	return false
}

// isUnsupportedBuiltin reports whether errStr is a nil-pointer on a Helm
// built-in object — inherently non-fixable by value injection (the data comes
// from Helm itself, not from values). e.g. ".Release.Time.Seconds".
// Documented and skipped by the fix loop.
func isUnsupportedBuiltin(errStr string) bool {
	return strings.Contains(errStr, "nil pointer") && builtinNilRe.MatchString(errStr)
}

// isMissingDependency reports whether errStr is an unbuilt-dependencies error.
// The fix loop uses it to stop once a `helm dependency build` has already been
// attempted without clearing the error.
func isMissingDependency(errStr string) bool {
	low := strings.ToLower(errStr)
	for _, m := range missingDependencyMarkers {
		if strings.Contains(low, m) {
			return true
		}
	}
	return false
}

// parseError parses a Helm render error and returns the fix kind, value path,
// and value to inject. ok is false for errors that cannot be fixed by value
// injection.
func parseError(errStr string) (kind, path, value string, ok bool) {
	s := strings.TrimPrefix(errStr, "Error: ")

	// 1. nil pointer: inject an empty value so the chain can build the missing
	//    parent map and re-render.
	if strings.Contains(s, "nil pointer") {
		if m := atValuesRe.FindStringSubmatch(s); m != nil {
			return kindNilPointer, strings.TrimPrefix(m[1], ".Values."), "", true
		}
	}

	// 2. wrong type where a string was expected: inject a string placeholder at
	//    the offending .Values path so the scalar type-checks.
	if strings.Contains(s, "wrong type for value") && strings.Contains(s, "expected string") {
		if m := atValuesRe.FindStringSubmatch(s); m != nil {
			return kindTypeMismatch, strings.TrimPrefix(m[1], ".Values."), kicsPlaceholder, true
		}
	}

	// 3. required/fail guards: recover the value path from the message text and
	//    inject a placeholder.
	if isRequiredMessage(s) {
		// "required value for <path> either as .value ..." needs the placeholder
		// at <path>.value, since the chart reads the .value sub-field.
		if m := requiredValueForRe.FindStringSubmatch(s); m != nil {
			return kindRequiredValue, m[1] + ".value", kicsPlaceholder, true
		}
		if p := extractRequiredPath(s); p != "" {
			return kindRequiredValue, p, kicsPlaceholder, true
		}
	}

	// 4. kubeVersion incompatibility: the chart's Chart.yaml constrains the
	//    Kubernetes version. Pick the highest version satisfying the constraint
	//    and re-render with --kube-version (value carries the picked version,
	//    path is empty since this is not a --set injection).
	if m := kubeVersionReqRe.FindStringSubmatch(s); m != nil {
		if v := pickKubeVersion(m[1]); v != "" {
			return kindKubeVersion, "", v, true
		}
	}

	return "", "", "", false
}

// ver is a stable Kubernetes version candidate.
type ver struct {
	maj, min, pat int
}

func (v ver) String() string { return fmt.Sprintf("%d.%d.%d", v.maj, v.min, v.pat) }

// cmpVer orders stable version candidates.
func cmpVer(a, b ver) int {
	for _, d := range []int{a.maj - b.maj, a.min - b.min, a.pat - b.pat} {
		if d != 0 {
			if d < 0 {
				return -1
			}
			return 1
		}
	}
	return 0
}

func parseVersionCandidate(m []string) ver {
	pat := 0
	if m[4] != "" {
		pat, _ = strconv.Atoi(m[4])
	}
	maj, _ := strconv.Atoi(m[2])
	minor, _ := strconv.Atoi(m[3])
	return ver{maj, minor, pat}
}

// pickKubeVersion returns the highest candidate satisfying Helm's kubeVersion
// constraint syntax, or "" if no compatible candidate can be derived.
func pickKubeVersion(constraint string) string {
	// Candidates: explicit (non-prerelease) versions named in the constraint,
	// plus a descending sweep of plausible minors. Highest satisfying wins.
	seen := map[string]bool{}
	var cands []ver
	add := func(v ver) {
		if !seen[v.String()] {
			seen[v.String()] = true
			cands = append(cands, v)
		}
	}
	for _, m := range clauseRe.FindAllStringSubmatch(constraint, -1) {
		v := parseVersionCandidate(m)
		add(v)
		// Include neighbors for strict patch bounds such as >1.30.0 <1.31.0.
		add(ver{v.maj, v.min, v.pat + 1})
		if v.pat > 0 {
			add(ver{v.maj, v.min, v.pat - 1})
		}
	}
	for minor := 34; minor >= 10; minor-- {
		add(ver{1, minor, 0})
	}
	sort.Slice(cands, func(i, j int) bool { return cmpVer(cands[i], cands[j]) > 0 })

	// Use Helm's own evaluator for ranges, wildcards, tilde/caret operators
	// and prereleases instead of interpreting regex matches as exact clauses.
	for _, c := range cands {
		if chartutil.IsCompatibleRange(constraint, c.String()) {
			return c.String()
		}
	}
	return ""
}

// isRequiredMessage reports whether s reads like a "value must be provided"
// failure raised by the `required` builtin or a `fail` guard.
func isRequiredMessage(s string) bool {
	low := strings.ToLower(s)
	for _, m := range requiredMarkers {
		if strings.Contains(low, m) {
			return true
		}
	}
	return false
}

// extractRequiredPath pulls a ".Values" value path out of a required/fail
// message, returning "" when no path can be recovered.
func extractRequiredPath(s string) string {
	// Explicit .Values.x.y references are unambiguous, so try them first on the
	// whole error string (covers `required .Values.x "msg"` SDK errors).
	if m := valuesPathRe.FindStringSubmatch(s); m != nil {
		return normalizeValuePath(m[1])
	}
	// Otherwise inspect only the human message, stripping the SDK location
	// envelope so we don't mistake a "templates/foo.yaml" path for a value path.
	body := messageBody(s)
	for _, re := range requiredPathRes {
		if m := re.FindStringSubmatch(body); m != nil {
			return normalizeValuePath(m[1])
		}
	}
	return ""
}

// normalizeValuePath strips a leading dot and a redundant "Values."/"values."
// prefix that hand-written messages sometimes include (e.g. a chart that writes
// ".values.loadBalancer" really means the value loadBalancer).
func normalizeValuePath(p string) string {
	p = strings.TrimPrefix(p, ".")
	if strings.HasPrefix(p, "Values.") {
		return p[len("Values."):]
	}
	if strings.HasPrefix(p, "values.") {
		return p[len("values."):]
	}
	return p
}

// messageBody strips the "execution error at (PATH:line:col): " envelope that
// the Helm SDK wraps around custom error messages, returning the message text.
func messageBody(s string) string {
	const marker = "execution error at ("
	if i := strings.Index(s, marker); i >= 0 {
		rest := s[i+len(marker):]
		if j := strings.Index(rest, "): "); j >= 0 {
			return rest[j+len("): "):]
		}
	}
	return s
}

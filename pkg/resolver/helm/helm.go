package helm

import (
	"fmt"
	"io"
	"log"
	"os"
	"path/filepath"
	"strings"

	"github.com/pkg/errors"
	zlog "github.com/rs/zerolog/log"
	"helm.sh/helm/v3/pkg/action"
	"helm.sh/helm/v3/pkg/chart"
	"helm.sh/helm/v3/pkg/chart/loader"
	"helm.sh/helm/v3/pkg/chartutil"
	"helm.sh/helm/v3/pkg/cli"
	"helm.sh/helm/v3/pkg/cli/values"
	"helm.sh/helm/v3/pkg/downloader"
	"helm.sh/helm/v3/pkg/getter"
	"helm.sh/helm/v3/pkg/registry"
	"helm.sh/helm/v3/pkg/release"
	"helm.sh/helm/v3/pkg/strvals"
)

// credit: https://github.com/helm/helm

var (
	settings = cli.New()
)

func runInstall(args []string, client *action.Install,
	valueOpts *values.Options, fixRender bool, explicit map[string]interface{}) (*release.Release, []string, error) {
	log.SetOutput(io.Discard)
	defer log.SetOutput(os.Stderr)
	if client.Version == "" && client.Devel {
		client.Version = ">0.0.0-0"
	}

	name, charts, err := client.NameAndChart(args)
	if err != nil {
		return nil, []string{}, err
	}
	client.ReleaseName = name

	cp, err := client.LocateChart(charts, settings)
	if err != nil {
		return nil, []string{}, err
	}

	p := getter.All(settings)

	// Dependencies present in charts/ are loaded here; missing ones are only
	// vendored on demand, if and when the render fails (see renderWithFixer).
	chartRequested, err := loader.Load(cp)
	if err != nil {
		return nil, []string{}, err
	}

	excluded := getExcluded(chartRequested, cp)

	chartRequested = setID(chartRequested)

	if instErr := checkIfInstallable(chartRequested); instErr != nil {
		return nil, []string{}, instErr
	}

	client.Namespace = "kics-namespace"
	helmRelease, err := renderWithFixer(client, chartRequested, cp, valueOpts, p, fixRender, explicit)
	if err != nil {
		return nil, []string{}, err
	}
	return helmRelease, excluded, nil
}

// updateDependencies vendors into charts/ the subcharts that Chart.yaml declares
// but that are not on disk, mirroring `helm dependency build` and honoring an
// existing Chart.lock. It reports the reloaded chart and true only when
// something was actually fetched, so the
// caller knows a re-render is worth attempting.
//
// It is called ONLY after a render has already failed, and only with the helm
// fixer enabled: a chart that renders fine, or whose dependencies are already
// vendored, never reaches the network. All downloader output is discarded and
// every failure is non-fatal — false means "nothing changed, keep the original
// render error", preserving the fail-closed behavior.
func updateDependencies(client *action.Install, chartRequested *chart.Chart,
	chartPath string, providers getter.Providers) (*chart.Chart, bool) {
	req := chartRequested.Metadata.Dependencies
	if len(req) == 0 {
		return chartRequested, false
	}
	// Nothing missing from charts/ => the render failed for some other reason.
	if err := action.CheckDependencies(chartRequested, req); err == nil {
		return chartRequested, false
	}

	// The install client is built from an empty action.Configuration, so it has
	// no registry client; one is required to resolve OCI-hosted dependencies.
	if client.GetRegistryClient() == nil {
		regClient, regErr := registry.NewClient(registry.ClientOptWriter(io.Discard))
		if regErr != nil {
			zlog.Debug().Str("chart", chartRequested.Name()).Err(regErr).
				Msg("helm fixer: could not create registry client, skipping dependency update")
			return chartRequested, false
		}
		client.SetRegistryClient(regClient)
	}

	man := &downloader.Manager{
		Out:              io.Discard,
		ChartPath:        chartPath,
		Keyring:          client.ChartPathOptions.Keyring,
		SkipUpdate:       false,
		Getters:          providers,
		RegistryClient:   client.GetRegistryClient(),
		RepositoryConfig: settings.RepositoryConfig,
		RepositoryCache:  settings.RepositoryCache,
	}
	if err := man.Build(); err != nil {
		zlog.Debug().Str("chart", chartRequested.Name()).Err(err).
			Msg("helm fixer: dependency update failed, keeping the original render error")
		return chartRequested, false
	}

	// Reload to pick up the updated Chart.lock and the newly vendored charts/.
	reloaded, err := loader.Load(chartPath)
	if err != nil {
		zlog.Debug().Str("chart", chartRequested.Name()).Err(err).
			Msg("helm fixer: failed reloading chart after dependency update")
		return chartRequested, false
	}
	zlog.Debug().Str("chart", reloaded.Name()).Int("dependencies", len(req)).
		Msg("helm fixer: vendored missing chart dependencies, re-rendering")
	// The reload came straight off disk, so re-apply the auxiliary line markers
	// the detector relies on.
	return setID(reloaded), true
}

// renderWithFixer renders the chart with client.Run. When fixRender is false it
// behaves exactly as before: a single render, returning any error untouched.
//
// When fixRender is true it engages the helm fixer loop: on a render error it
// classifies the failure (see parseError) and injects a placeholder value
// (--set) or a kubeVersion override, then re-renders, looping up to
// maxFixIterations. The loop stops early when an error repeats (no progress),
// when the error is unfixable by value injection, or when it is a documented
// non-fixable class (malformed YAML, a nil-pointer on a Helm built-in, or
// missing dependencies that could not be vendored). On any stop the current
// render error is returned.
//
// A failure while declared subcharts are missing from charts/ is the one class
// not repaired by value injection: it triggers a single `helm dependency build`
// (see updateDependencies) followed by a re-render.
func renderWithFixer(client *action.Install, chartRequested *chart.Chart, chartPath string,
	valueOpts *values.Options, providers getter.Providers, fixRender bool, explicit map[string]interface{}) (*release.Release, error) {
	patch := map[string]string{}
	seenErrs := map[string]bool{}
	depsTried := false

	for attempt := 1; attempt <= maxFixIterations; attempt++ {
		// Install.Run mutates the chart (including pruning disabled subcharts).
		// Each retry must start with the full chart and fresh line markers.
		if attempt > 1 {
			reloaded, err := loader.Load(chartPath)
			if err != nil {
				return nil, err
			}
			chartRequested = setID(reloaded)
		}
		vals, err := mergeValuesWithPatch(valueOpts, patch, providers)
		if err != nil {
			// The values themselves (a -f file or a prior --set) do not parse;
			// no further --set injection can repair that.
			return nil, err
		}
		// Explicit user settings win over discovered values and fixer patches.
		// Merge into a fresh tree because Helm mutates values while rendering.
		vals = mergeOverrideMaps(vals, explicit)

		// Unlike the Helm CLI, Install.Run does not check for missing charts.
		// Check before rendering so a missing dependency cannot silently vanish
		// from a successful scan and the fixer can fetch it when enabled.
		var helmRelease *release.Release
		runErr := action.CheckDependencies(chartRequested, chartRequested.Metadata.Dependencies)
		if runErr == nil {
			helmRelease, runErr = client.Run(chartRequested, vals)
		}
		if runErr == nil {
			if attempt > 1 {
				zlog.Debug().Str("chart", chartRequested.Name()).Int("attempts", attempt).
					Msg("helm fixer: render resolved after value injection")
			}
			return helmRelease, nil
		}

		// Without the fixer, preserve the original single-render behavior.
		if !fixRender {
			return nil, runErr
		}

		errStr := runErr.Error()

		// Repeated identical error => the last injection made no progress. Stop.
		if seenErrs[errStr] {
			return nil, runErr
		}
		seenErrs[errStr] = true

		// Documented non-fixable classes: no value injection can help, so log and
		// stop rather than spin. (Kept explicit per the fixer design.)
		switch {
		case isUnparseableYAML(errStr):
			zlog.Debug().Str("chart", chartRequested.Name()).
				Msg("helm fixer: skipping non-fixable malformed YAML")
			return nil, runErr
		case isUnsupportedBuiltin(errStr):
			zlog.Debug().Str("chart", chartRequested.Name()).
				Msg("helm fixer: skipping non-fixable nil pointer on helm built-in")
			return nil, runErr
		}

		// The render failed and subcharts are still missing from charts/: fetch
		// them once and retry. Tried before value injection, since the templates
		// the chart is missing cannot be conjured with --set. If nothing is
		// fetched, fall through and treat it as a normal fixable error.
		if !depsTried && isMissingDependency(errStr) {
			depsTried = true
			if updated, ok := updateDependencies(client, chartRequested, chartPath, providers); ok {
				chartRequested = updated
				// Vendoring changed what is being rendered, so the errors seen so
				// far say nothing about progress from here on. Without this reset
				// the current error is already marked as seen and the re-render
				// trips the "no progress" guard below, aborting before a single
				// value is ever injected.
				seenErrs = map[string]bool{}
				continue
			}
		}

		// Still complaining about dependencies after the update: give up.
		if isMissingDependency(errStr) {
			zlog.Debug().Str("chart", chartRequested.Name()).
				Msg("helm fixer: missing dependencies could not be vendored")
			return nil, runErr
		}

		kind, path, value, ok := parseError(errStr)
		if !ok {
			return nil, runErr
		}

		if kind == kindKubeVersion {
			// kubeVersion is a render-wide override, not a --set value.
			if kv, kvErr := chartutil.ParseKubeVersion(value); kvErr == nil {
				client.KubeVersion = kv
			}
			continue
		}
		path = scopeDependencyValuePath(errStr, path)
		candidate := map[string]interface{}{}
		if err := strvals.ParseIntoString(path+"="+value, candidate); err != nil {
			return nil, runErr
		}
		if patchOverwritesExplicit(candidate, explicit) {
			return nil, errors.Errorf("helm fixer cannot repair %q without replacing an explicit override", path)
		}
		patch[path] = value
	}

	return nil, errors.Errorf("helm fixer: exhausted %d fix iterations", maxFixIterations)
}

// mergeValuesWithPatch merges the chart's configured value options together with
// the fixer's accumulated --set patch (path=value) overrides.
func mergeValuesWithPatch(valueOpts *values.Options, patch map[string]string,
	providers getter.Providers) (map[string]interface{}, error) {
	if len(patch) == 0 {
		return valueOpts.MergeValues(providers)
	}
	extra := make([]string, 0, len(patch))
	for k, v := range patch {
		extra = append(extra, fmt.Sprintf("%s=%s", k, v))
	}
	merged := &values.Options{
		ValueFiles:    valueOpts.ValueFiles,
		Values:        append(append([]string{}, valueOpts.Values...), extra...),
		StringValues:  valueOpts.StringValues,
		FileValues:    valueOpts.FileValues,
		JSONValues:    valueOpts.JSONValues,
		LiteralValues: valueOpts.LiteralValues,
	}
	return merged.MergeValues(providers)
}

// checkIfInstallable validates if a chart can be installed
//
// Application chart type is only installable
func checkIfInstallable(ch *chart.Chart) error {
	switch ch.Metadata.Type {
	case "", "application":
		return nil
	}
	return errors.Errorf("%s charts are not installable", ch.Metadata.Type)
}

// newClient will create a new instance on helm client used to render the chart
func newClient() *action.Install {
	cfg := new(action.Configuration)
	client := action.NewInstall(cfg)
	client.DryRun = true
	client.ReleaseName = "kics-helm"
	client.Replace = true // Skip the name check
	client.ClientOnly = true
	client.APIVersions = chartutil.VersionSet([]string{})
	client.IncludeCRDs = false
	return client
}

// setID will add auxiliary lines for each template as well as its dependencies
func setID(chartReq *chart.Chart) *chart.Chart {
	for _, temp := range chartReq.Templates {
		temp = addID(temp)
		if temp != nil {
			continue
		}
	}
	for _, dep := range chartReq.Dependencies() {
		dep = setID(dep)
		if dep != nil {
			continue
		}
	}
	return chartReq
}

// addID will add auxiliary lines used to detect line
// one for each "apiVersion:" where the id will be the line
func addID(file *chart.File) *chart.File {
	split := strings.Split(string(file.Data), "\n")
	for i := 0; i < len(split); i++ {
		if strings.Contains(split[i], "apiVersion:") {
			split = append(split, "")
			copy(split[i+1:], split[i:])
			split[i] = fmt.Sprintf("# KICS_HELM_ID_%d:", i)
			i++
		}
	}
	file.Data = []byte(strings.Join(split, "\n"))
	return file
}

// getExcluded will return all files rendered to be excluded from scan
func getExcluded(chartData *chart.Chart, chartPath string) []string {
	excluded := make([]string, 0)
	for _, file := range chartData.Raw {
		excluded = append(excluded, filepath.Join(chartPath, file.Name))
	}

	return excluded
}

package helm

import (
	"fmt"
	"os"
	"path/filepath"
	"runtime"
	"sort"
	"strings"
	"sync"

	"helm.sh/helm/v3/pkg/cli/values"
	"helm.sh/helm/v3/pkg/strvals"
)

// OverrideValues describes one ordered layer of explicit Helm values.
type OverrideValues struct {
	ValuesFiles []string `json:"values-files"`
	Set         []string `json:"set"`
	SetString   []string `json:"set-string"`
}

// ChartOverrides applies values to a chart directory, not its metadata name.
type ChartOverrides struct {
	Path string `json:"path"`
	OverrideValues
}

// OverrideConfig is shared by configuration-file and command-line inputs.
type OverrideConfig struct {
	Global OverrideValues   `json:"global"`
	Charts []ChartOverrides `json:"charts"`
}

type overrideLayer struct {
	chart  string
	values map[string]interface{}
	files  []string
	active bool
}

// Overrides holds validated, immutable values and tracks chart selector usage.
// PrepareOverrides must be called before starting the scan.
type Overrides struct {
	layers  []overrideLayer
	mu      sync.Mutex
	matched map[string]bool
}

// PrepareOverrides validates inputs and snapshots values files before scanning.
// Paths use their source's base directory. CLI layers follow config layers.
func PrepareOverrides(config, cli OverrideConfig, configDir, workingDir string) (*Overrides, error) {
	o := &Overrides{matched: make(map[string]bool)}
	for _, source := range []struct {
		config OverrideConfig
		base   string
	}{{config, configDir}, {cli, workingDir}} {
		global, err := prepareOverrideLayer(source.config.Global, source.base)
		if err != nil {
			return nil, err
		}
		o.layers = append(o.layers, global)
		seen := make(map[string]bool)
		for _, rule := range source.config.Charts {
			path, err := canonicalOverridePath(rule.Path, source.base)
			if err != nil {
				return nil, fmt.Errorf("invalid Helm chart selector: %w", err)
			}
			info, err := os.Stat(filepath.Join(path, "Chart.yaml"))
			if err != nil || !info.Mode().IsRegular() {
				return nil, fmt.Errorf("Helm chart selector %q must identify a directory containing Chart.yaml", rule.Path)
			}
			if seen[path] {
				return nil, fmt.Errorf("duplicate Helm chart selector %q", rule.Path)
			}
			seen[path] = true
			layer, err := prepareOverrideLayer(rule.OverrideValues, source.base)
			if err != nil {
				return nil, fmt.Errorf("Helm chart %q: %w", rule.Path, err)
			}
			layer.chart = path
			o.layers = append(o.layers, layer)
			o.matched[path] = false
		}
	}
	return o, nil
}

func canonicalOverridePath(path, base string) (string, error) {
	if strings.TrimSpace(path) == "" {
		return "", fmt.Errorf("path cannot be empty")
	}
	path = filepath.FromSlash(strings.ReplaceAll(path, `\`, "/"))
	if !filepath.IsAbs(path) {
		path = filepath.Join(base, path)
	}
	path, err := filepath.Abs(path)
	if err != nil {
		return "", err
	}
	if resolved, err := filepath.EvalSymlinks(path); err == nil {
		path = resolved
	}
	if runtime.GOOS == "windows" {
		path = strings.ToLower(path)
	}
	return filepath.Clean(path), nil
}

func prepareOverrideLayer(input OverrideValues, base string) (overrideLayer, error) {
	layer := overrideLayer{
		values: map[string]interface{}{},
		active: len(input.ValuesFiles)+len(input.Set)+len(input.SetString) != 0,
	}
	for _, file := range input.ValuesFiles {
		path, err := canonicalOverridePath(file, base)
		if err != nil {
			return layer, err
		}
		info, err := os.Stat(path)
		if err != nil || !info.Mode().IsRegular() {
			return layer, fmt.Errorf("Helm values file %q must be a readable local file", file)
		}
		data, err := (&values.Options{ValueFiles: []string{path}}).MergeValues(nil)
		if err != nil {
			return layer, fmt.Errorf("cannot read Helm values file %q as a YAML mapping", file)
		}
		layer.values = mergeOverrideMaps(layer.values, data)
		layer.files = append(layer.files, path)
	}
	for _, group := range []struct {
		name  string
		items []string
		parse func(string, map[string]interface{}) error
	}{{"set", input.Set, strvals.ParseInto}, {"set-string", input.SetString, strvals.ParseIntoString}} {
		for i, expression := range group.items {
			if strings.TrimSpace(expression) == "" || group.parse(expression, layer.values) != nil {
				// Do not include potentially secret values in diagnostics.
				return layer, fmt.Errorf("invalid Helm %s expression at position %d", group.name, i+1)
			}
		}
	}
	return layer, nil
}

// forChart returns a fresh values tree for one render, plus files to exclude
// from experimental discovery. Shared prepared layers are never mutated.
func (o *Overrides) forChart(path string) (map[string]interface{}, map[string]bool, bool) {
	merged, files := map[string]interface{}{}, map[string]bool{}
	if o == nil {
		return merged, files, false
	}
	canonical, _ := canonicalOverridePath(path, ".")
	o.mu.Lock()
	if _, exists := o.matched[canonical]; exists {
		o.matched[canonical] = true
	}
	o.mu.Unlock()
	active := false
	for _, layer := range o.layers {
		if layer.chart != "" && layer.chart != canonical {
			continue
		}
		merged = mergeOverrideMaps(merged, layer.values)
		active = active || layer.active
		for _, file := range layer.files {
			files[file] = true
		}
	}
	return merged, files, active
}

// UnmatchedCharts reports selectors not encountered by the resolver.
func (o *Overrides) UnmatchedCharts() []string {
	if o == nil {
		return nil
	}
	o.mu.Lock()
	defer o.mu.Unlock()
	var paths []string
	for path, matched := range o.matched {
		if !matched {
			paths = append(paths, path)
		}
	}
	sort.Strings(paths)
	return paths
}

func mergeOverrideMaps(base, overlay map[string]interface{}) map[string]interface{} {
	result := cloneOverrideValue(base).(map[string]interface{})
	for key, value := range overlay {
		if child, ok := value.(map[string]interface{}); ok {
			if previous, ok := result[key].(map[string]interface{}); ok {
				result[key] = mergeOverrideMaps(previous, child)
				continue
			}
		}
		result[key] = cloneOverrideValue(value)
	}
	return result
}

func cloneOverrideValue(value interface{}) interface{} {
	switch value := value.(type) {
	case map[string]interface{}:
		copy := make(map[string]interface{}, len(value))
		for key, item := range value {
			copy[key] = cloneOverrideValue(item)
		}
		return copy
	case []interface{}:
		copy := make([]interface{}, len(value))
		for i, item := range value {
			copy[i] = cloneOverrideValue(item)
		}
		return copy
	default:
		return value
	}
}

func patchOverwritesExplicit(patch, explicit map[string]interface{}) bool {
	for key, value := range patch {
		original, exists := explicit[key]
		if !exists {
			continue
		}
		child, patchIsMap := value.(map[string]interface{})
		protected, explicitIsMap := original.(map[string]interface{})
		if !patchIsMap || !explicitIsMap || len(protected) == 0 || patchOverwritesExplicit(child, protected) {
			return true
		}
	}
	return false
}

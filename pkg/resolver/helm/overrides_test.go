package helm

import (
	"path/filepath"
	"strings"
	"testing"

	"github.com/stretchr/testify/require"
	"helm.sh/helm/v3/pkg/cli/values"
)

func TestOverridesPrecedenceAndIsolation(t *testing.T) {
	configDir, cliDir := t.TempDir(), t.TempDir()
	chart, other := writeChart(t), writeChart(t)
	mustWrite(t, filepath.Join(configDir, "common.yaml"), "replicaCount: 1\nimage:\n  tag: default\nitems: [a, b]\n")
	mustWrite(t, filepath.Join(cliDir, "chart.yaml"), "replicaCount: 4\nitems: [c]\n")
	config := OverrideConfig{
		Global: OverrideValues{ValuesFiles: []string{"common.yaml"}, Set: []string{"enabled=false", "nullable=null"}},
		Charts: []ChartOverrides{{Path: chart, OverrideValues: OverrideValues{Set: []string{"replicaCount=2"}}}},
	}
	cli := OverrideConfig{
		Global: OverrideValues{Set: []string{"replicaCount=3"}, SetString: []string{"image.tag=001"}},
		Charts: []ChartOverrides{{Path: chart, OverrideValues: OverrideValues{
			ValuesFiles: []string{"chart.yaml"}, Set: []string{"replicaCount=5"}, SetString: []string{"replicaCount=006"},
		}}},
	}
	overrides, err := PrepareOverrides(config, cli, configDir, cliDir)
	require.NoError(t, err)
	require.Len(t, overrides.UnmatchedCharts(), 1)
	got, files, active := overrides.forChart(chart)
	require.True(t, active)
	require.Equal(t, "006", got["replicaCount"])
	require.Equal(t, map[string]interface{}{"tag": "001"}, got["image"])
	require.Equal(t, []interface{}{"c"}, got["items"])
	require.Equal(t, false, got["enabled"])
	require.Contains(t, got, "nullable")
	require.Nil(t, got["nullable"])
	require.Len(t, files, 2)
	require.Empty(t, overrides.UnmatchedCharts())

	// Mutation by one render must not affect later charts or contexts.
	got["image"].(map[string]interface{})["tag"] = "changed"
	got["items"].([]interface{})[0] = "changed"
	otherValues, _, _ := overrides.forChart(other)
	require.EqualValues(t, 3, otherValues["replicaCount"])
	require.Equal(t, "001", otherValues["image"].(map[string]interface{})["tag"])
	require.Equal(t, []interface{}{"a", "b"}, otherValues["items"])
	again, _, _ := overrides.forChart(chart)
	require.Equal(t, []interface{}{"c"}, again["items"])
}

func TestOverridesValidation(t *testing.T) {
	dir := t.TempDir()
	mustWrite(t, filepath.Join(dir, "invalid.yaml"), "[not, a, mapping]\n")
	for _, input := range []OverrideConfig{
		{Global: OverrideValues{ValuesFiles: []string{"missing.yaml"}}},
		{Global: OverrideValues{ValuesFiles: []string{"invalid.yaml"}}},
		{Global: OverrideValues{ValuesFiles: []string{dir}}},
		{Global: OverrideValues{Set: []string{"key"}}},
		{Global: OverrideValues{SetString: []string{""}}},
		{Charts: []ChartOverrides{{Path: "missing-chart"}}},
		{Charts: []ChartOverrides{{Path: ""}}},
	} {
		_, err := PrepareOverrides(input, OverrideConfig{}, dir, dir)
		require.Error(t, err)
	}
	chart := writeChart(t)
	_, err := PrepareOverrides(OverrideConfig{Charts: []ChartOverrides{{Path: chart}, {Path: chart}}}, OverrideConfig{}, dir, dir)
	require.ErrorContains(t, err, "duplicate")
}

func TestOverridesFileOrderAndSnapshot(t *testing.T) {
	dir := t.TempDir()
	mustWrite(t, filepath.Join(dir, "first.yaml"), "value: first\n")
	mustWrite(t, filepath.Join(dir, "second.yaml"), "value: second\n")
	overrides, err := PrepareOverrides(OverrideConfig{Global: OverrideValues{
		ValuesFiles: []string{"first.yaml", "second.yaml"},
	}}, OverrideConfig{}, dir, dir)
	require.NoError(t, err)
	mustWrite(t, filepath.Join(dir, "second.yaml"), "value: changed\n")
	got, _, _ := overrides.forChart(dir)
	require.Equal(t, "second", got["value"])
}

func TestOverridesWorkWithoutExperimentalMode(t *testing.T) {
	dir := writeChart(t)
	overrides, err := PrepareOverrides(OverrideConfig{Global: OverrideValues{
		SetString: []string{"image.repository=provided"},
	}}, OverrideConfig{}, dir, dir)
	require.NoError(t, err)
	result, err := (&Resolver{Overrides: overrides}).Resolve(dir)
	require.NoError(t, err)
	require.Len(t, result.File, 1)
	require.Contains(t, string(result.File[0].Content), `repo: "provided"`)
	require.Equal(t, "configured", result.File[0].ContextSelector)
	require.NotContains(t, string(result.File[0].Content), kicsPlaceholder)
}

func TestExperimentalOverridesApplyToEveryCombination(t *testing.T) {
	dir := writeChart(t)
	mustWrite(t, filepath.Join(dir, "explicit.yaml"), "image:\n  repository: explicit\n")
	mustWrite(t, filepath.Join(dir, "variant.yaml"), "image:\n  repository: discovered\n")
	overrides, err := PrepareOverrides(OverrideConfig{Global: OverrideValues{
		ValuesFiles: []string{"explicit.yaml"},
	}}, OverrideConfig{}, dir, dir)
	require.NoError(t, err)
	renders, _, err := renderHelm(dir, true, overrides)
	require.NoError(t, err)
	require.Len(t, renders, 2, "explicit values files must not be auto-discovered")
	for _, key := range []string{"configured", "configured+variant.yaml"} {
		require.Contains(t, renders, key)
		require.Len(t, *renders[key], 1)
		require.Contains(t, string((*renders[key])[0].content), `repo: "explicit"`)
	}
}

func TestFixerProtectsExplicitValues(t *testing.T) {
	for _, expression := range []string{"image.repository=", "image.repository=false", "image.repository=null", "image=blocked"} {
		t.Run(expression, func(t *testing.T) {
			dir := writeChart(t)
			layer, err := prepareOverrideLayer(OverrideValues{Set: []string{expression}}, dir)
			require.NoError(t, err)
			_, _, err = runInstall([]string{dir}, newClient(), &values.Options{}, true, layer.values)
			require.Error(t, err)
			if expression != "image=blocked" { // Helm cannot evaluate this scalar parent at all.
				require.ErrorContains(t, err, "explicit override")
			}
		})
	}
}

func TestFixerCanRepairUnspecifiedSibling(t *testing.T) {
	dir := writeChart(t)
	explicit := map[string]interface{}{"image": map[string]interface{}{"tag": "001"}}
	rel, _, err := runInstall([]string{dir}, newClient(), &values.Options{}, true, explicit)
	require.NoError(t, err)
	require.Contains(t, rel.Manifest, kicsPlaceholder)
	require.Equal(t, "001", explicit["image"].(map[string]interface{})["tag"])
}

func TestPatchProtectionHandlesParentsAndLists(t *testing.T) {
	for _, test := range []struct {
		explicit map[string]interface{}
		patch    map[string]interface{}
		conflict bool
	}{
		{map[string]interface{}{"parent": map[string]interface{}{"child": "user"}}, map[string]interface{}{"parent": "patch"}, true},
		{map[string]interface{}{"parent": nil}, map[string]interface{}{"parent": map[string]interface{}{"child": "patch"}}, true},
		{map[string]interface{}{"list": []interface{}{"user"}}, map[string]interface{}{"list": []interface{}{"patch"}}, true},
		{map[string]interface{}{"parent": map[string]interface{}{}}, map[string]interface{}{"parent": map[string]interface{}{"child": "patch"}}, true},
		{map[string]interface{}{"parent": map[string]interface{}{"user": false}}, map[string]interface{}{"parent": map[string]interface{}{"other": "patch"}}, false},
	} {
		require.Equal(t, test.conflict, patchOverwritesExplicit(test.patch, test.explicit))
	}
}

func TestChartSelectorsNormalizePaths(t *testing.T) {
	dir := writeChart(t)
	input := OverrideConfig{Charts: []ChartOverrides{{
		Path:           strings.ReplaceAll(dir, string(filepath.Separator), `\`),
		OverrideValues: OverrideValues{Set: []string{"replicaCount=2"}},
	}}}
	overrides, err := PrepareOverrides(input, OverrideConfig{}, ".", ".")
	require.NoError(t, err)
	values, _, _ := overrides.forChart(filepath.Join(dir, "templates", ".."))
	require.EqualValues(t, 2, values["replicaCount"])
	require.Empty(t, overrides.UnmatchedCharts())
}

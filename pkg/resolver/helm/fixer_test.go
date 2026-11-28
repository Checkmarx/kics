package helm

import (
	"os"
	"path/filepath"
	"testing"

	"github.com/stretchr/testify/require"
	"helm.sh/helm/v3/pkg/chartutil"
	"helm.sh/helm/v3/pkg/cli/values"
)

// writeChart lays down a minimal chart whose template uses `required` so a plain
// render fails until the value is injected.
func writeChart(t *testing.T) string {
	t.Helper()
	dir := t.TempDir()
	mustWrite(t, filepath.Join(dir, "Chart.yaml"),
		"apiVersion: v2\nname: fixme\nversion: 0.1.0\n")
	if err := os.MkdirAll(filepath.Join(dir, "templates"), 0o755); err != nil {
		t.Fatal(err)
	}
	mustWrite(t, filepath.Join(dir, "values.yaml"), "image: {}\n")
	// `required` fails the render until image.repository is set; nil-map access on
	// image.tag would also fail — both are fixer-recoverable.
	mustWrite(t, filepath.Join(dir, "templates", "cm.yaml"),
		"apiVersion: v1\nkind: ConfigMap\nmetadata:\n  name: cm\ndata:\n"+
			"  repo: {{ required \"image.repository is required\" .Values.image.repository | quote }}\n")
	return dir
}

func mustWrite(t *testing.T, path, content string) {
	t.Helper()
	if err := os.WriteFile(path, []byte(content), 0o644); err != nil {
		t.Fatal(err)
	}
}

// Piped-form type mismatch: `{{ .Values.val | trimPrefix "http://" }}` puts the
// string literal in at<>, not the .Values. path — unfixable, no --set target visible.
func TestParseError_WrongTypePipedForm(t *testing.T) {
	errStr := `Error: template: mychart/templates/cm.yaml:5:30: executing "mychart/templates/cm.yaml" at <"http://">: wrong type for value; expected string; got map[string]interface {}`
	if _, _, _, ok := parseError(errStr); ok {
		t.Fatal("expected unfixable (piped form hides .Values. path), got parseable")
	}
}

func TestFixerRecoversRequiredValue(t *testing.T) {
	dir := writeChart(t)

	// Without the fixer the render must fail (current fail-closed behavior).
	_, _, err := runInstall([]string{dir}, newClient(), &values.Options{}, false, nil)
	if err == nil {
		t.Fatal("expected plain render to fail on required value, got nil")
	}

	// With the fixer the chart should render after the placeholder is injected.
	rel, _, err := runInstall([]string{dir}, newClient(), &values.Options{}, true, nil)
	if err != nil {
		t.Fatalf("expected fixer to resolve render, got error: %v", err)
	}
	if rel == nil || rel.Manifest == "" {
		t.Fatal("expected a non-empty manifest from the fixed render")
	}
	t.Logf("fixed manifest:\n%s", rel.Manifest)
}

func writeDependencyChart(t *testing.T, alias string, nested bool) string {
	t.Helper()
	root := t.TempDir()
	mustWrite(t, filepath.Join(root, "Chart.yaml"),
		"apiVersion: v2\nname: parent\nversion: 0.1.0\ndependencies:\n"+
			"  - name: child\n    alias: "+alias+"\n    version: 0.1.0\n")
	mustWrite(t, filepath.Join(root, "values.yaml"), "{}\n")

	child := filepath.Join(root, "charts", "child")
	require.NoError(t, os.MkdirAll(filepath.Join(child, "templates"), 0o755))
	childChart := "apiVersion: v2\nname: child\nversion: 0.1.0\n"
	if nested {
		childChart += "dependencies:\n  - name: grandchild\n    alias: database\n    version: 0.1.0\n"
	}
	mustWrite(t, filepath.Join(child, "Chart.yaml"), childChart)
	mustWrite(t, filepath.Join(child, "values.yaml"), "{}\n")

	templateChart := child
	if nested {
		templateChart = filepath.Join(child, "charts", "grandchild")
		require.NoError(t, os.MkdirAll(filepath.Join(templateChart, "templates"), 0o755))
		mustWrite(t, filepath.Join(templateChart, "Chart.yaml"),
			"apiVersion: v2\nname: grandchild\nversion: 0.1.0\n")
		mustWrite(t, filepath.Join(templateChart, "values.yaml"), "{}\n")
	}
	mustWrite(t, filepath.Join(templateChart, "templates", "cm.yaml"),
		"apiVersion: v1\nkind: ConfigMap\nmetadata:\n  name: dependency\ndata:\n"+
			"  host: {{ .Values.config.database.host | quote }}\n"+
			"  token: {{ required \"credentials.token is required\" .Values.credentials.token | quote }}\n")
	return root
}

func TestFixerRecoversAliasedSubchartValue(t *testing.T) {
	dir := writeDependencyChart(t, "worker", false)

	_, _, err := runInstall([]string{dir}, newClient(), &values.Options{}, false, nil)
	require.ErrorContains(t, err, "nil pointer")

	rel, _, err := runInstall([]string{dir}, newClient(), &values.Options{}, true, nil)
	require.NoError(t, err)
	require.Contains(t, rel.Manifest, "name: dependency")
	require.Contains(t, rel.Manifest, kicsPlaceholder)
}

func TestFixerRecoversNestedSubchartValue(t *testing.T) {
	dir := writeDependencyChart(t, "worker", true)

	rel, _, err := runInstall([]string{dir}, newClient(), &values.Options{}, true, nil)
	require.NoError(t, err)
	require.Contains(t, rel.Manifest, "name: dependency")
	require.Contains(t, rel.Manifest, kicsPlaceholder)
}

func TestScopeDependencyValuePath(t *testing.T) {
	tests := []struct {
		name, errStr, path, want string
	}{
		{
			name:   "root chart",
			errStr: `template: parent/templates/cm.yaml:5:10: executing "parent/templates/cm.yaml" at <.Values.config.host>: nil pointer`,
			path:   "config.host",
			want:   "config.host",
		},
		{
			name:   "aliased nested dependencies",
			errStr: `template: parent/charts/worker/charts/database/templates/cm.yaml:5:10: executing "cm" at <.Values.config.host>: nil pointer`,
			path:   "config.host",
			want:   "worker.database.config.host",
		},
		{
			name:   "global value",
			errStr: `template: parent/charts/worker/templates/cm.yaml:5:10: executing "cm" at <.Values.global.host>: nil pointer`,
			path:   "global.host",
			want:   "global.host",
		},
		{
			name:   "already qualified custom error",
			errStr: `template: parent/charts/worker/templates/cm.yaml:5:10: executing "cm" at <required>: error calling required: worker.config.host is required`,
			path:   "worker.config.host",
			want:   "worker.config.host",
		},
		{
			name:   "required error location",
			errStr: `execution error at (parent/charts/worker/templates/cm.yaml:5:10): config.host is required`,
			path:   "config.host",
			want:   "worker.config.host",
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			require.Equal(t, tt.want, scopeDependencyValuePath(tt.errStr, tt.path))
		})
	}
}

func TestFixerFetchesMissingLocalDependency(t *testing.T) {
	dir := writeChart(t)
	child := filepath.Join(t.TempDir(), "child")
	require.NoError(t, os.MkdirAll(filepath.Join(child, "templates"), 0755))
	mustWrite(t, filepath.Join(child, "Chart.yaml"), "apiVersion: v2\nname: child\nversion: 0.1.0\n")
	mustWrite(t, filepath.Join(child, "values.yaml"), "{}\n")
	mustWrite(t, filepath.Join(child, "templates", "cm.yaml"),
		"apiVersion: v1\nkind: ConfigMap\nmetadata:\n  name: dependency\ndata:\n"+
			"  host: {{ .Values.config.database.host | quote }}\n")
	repositoryPath, err := filepath.Rel(dir, child)
	require.NoError(t, err)
	mustWrite(t, filepath.Join(dir, "Chart.yaml"),
		"apiVersion: v2\nname: fixme\nversion: 0.1.0\ndependencies:\n"+
			"  - name: child\n    version: 0.1.0\n    repository: file://"+filepath.ToSlash(repositoryPath)+"\n")
	mustWrite(t, filepath.Join(dir, "values.yaml"), "image:\n  repository: example\n")

	_, _, err = runInstall([]string{dir}, newClient(), &values.Options{}, false, nil)
	require.ErrorContains(t, err, "missing in charts/ directory")
	_, err = os.Stat(filepath.Join(dir, "charts"))
	require.True(t, os.IsNotExist(err), "ordinary rendering must not fetch dependencies")

	rel, _, err := runInstall([]string{dir}, newClient(), &values.Options{}, true, nil)
	require.NoError(t, err)
	require.Contains(t, rel.Manifest, "name: dependency")
	require.Contains(t, rel.Manifest, `host: ""`)
}

func TestFixerRestoresDisabledDependencyOnRetry(t *testing.T) {
	dir := writeChart(t)
	child := filepath.Join(dir, "charts", "child")
	require.NoError(t, os.MkdirAll(filepath.Join(child, "templates"), 0755))
	mustWrite(t, filepath.Join(child, "Chart.yaml"), "apiVersion: v2\nname: child\nversion: 0.1.0\n")
	mustWrite(t, filepath.Join(child, "templates", "cm.yaml"),
		"apiVersion: v1\nkind: ConfigMap\nmetadata:\n  name: dependency\n")
	mustWrite(t, filepath.Join(dir, "Chart.yaml"),
		"apiVersion: v2\nname: fixme\nversion: 0.1.0\ndependencies:\n"+
			"  - name: child\n    version: 0.1.0\n    condition: child.enabled\n")
	mustWrite(t, filepath.Join(dir, "values.yaml"), "child:\n  enabled: false\nimage: {}\n")
	rel, _, err := runInstall([]string{dir}, newClient(), &values.Options{}, true, nil)
	require.NoError(t, err)
	require.Contains(t, rel.Manifest, kicsPlaceholder)
	require.NotContains(t, rel.Manifest, "name: dependency")
}

func TestPickKubeVersionUsesHelmConstraints(t *testing.T) {
	for _, constraint := range []string{
		">1.30.0 <1.31.0", "1.25.0 - 1.30.0", "1.29.x", "~1.29.0", "^1.29.0",
		">=1.99.0-0 <1.100.0", "1.28.0 || 1.29.0",
	} {
		t.Run(constraint, func(t *testing.T) {
			version := pickKubeVersion(constraint)
			require.NotEmpty(t, version)
			require.True(t, chartutil.IsCompatibleRange(constraint, version), "%s must satisfy %s", version, constraint)
		})
	}
	require.Empty(t, pickKubeVersion("invalid 1.30.0"))
	require.Empty(t, pickKubeVersion(">1.30.0 <1.30.0"))
}

package console

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"testing"

	"github.com/Checkmarx/kics/v2/internal/console/flags"
	"github.com/Checkmarx/kics/v2/pkg/resolver/helm"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
	"github.com/stretchr/testify/require"
)

func helmTestCommand(t *testing.T, args ...string) *cobra.Command {
	t.Helper()
	cmd := NewScanCmd()
	require.NoError(t, initScanCmd(cmd))
	require.NoError(t, cmd.ParseFlags(args))
	return cmd
}

func TestHelmCLIExpressionsPreserveCommasAndTypes(t *testing.T) {
	cmd := helmTestCommand(t,
		"--helm-set", "items={one,two}", "--helm-set", "replicaCount=2",
		"--helm-set-string", `message=hello\,world`,
		"--helm-chart-values", `C:\charts\api::C:\values\prod.yaml`,
		"--helm-chart-set", `C:\charts\api::service.port=80`,
		"--helm-chart-set-string", `C:\charts\api::image.tag=001`,
	)
	got, err := helmCLIOverrides(cmd, viper.New())
	require.NoError(t, err)
	require.Equal(t, []string{"items={one,two}", "replicaCount=2"}, got.Global.Set)
	require.Equal(t, []string{`message=hello\,world`}, got.Global.SetString)
	require.Len(t, got.Charts, 1)
	require.Equal(t, `C:\charts\api`, got.Charts[0].Path)
	require.Equal(t, []string{`C:\values\prod.yaml`}, got.Charts[0].ValuesFiles)
	require.Equal(t, []string{"service.port=80"}, got.Charts[0].Set)
	require.Equal(t, []string{"image.tag=001"}, got.Charts[0].SetString)
}

func TestHelmConfigAndCLIPrecedence(t *testing.T) {
	for format, body := range map[string]string{
		"yaml": "helm-overrides:\n  global:\n    values-files: [common.yaml]\n    set-string: [image.tag=001]\n  charts:\n    - path: chart\n      set: [replicaCount=2]\n",
		"json": `{"helm-overrides":{"global":{"values-files":["common.yaml"],"set-string":["image.tag=001"]},"charts":[{"path":"chart","set":["replicaCount=2"]}]}}`,
		"toml": "[helm-overrides.global]\nvalues-files = [\"common.yaml\"]\nset-string = [\"image.tag=001\"]\n[[helm-overrides.charts]]\npath = \"chart\"\nset = [\"replicaCount=2\"]\n",
	} {
		t.Run(format, func(t *testing.T) {
			dir := t.TempDir()
			chart := filepath.Join(dir, "chart")
			require.NoError(t, os.MkdirAll(filepath.Join(chart, "templates"), 0755))
			files := map[string]string{
				"Chart.yaml":  "apiVersion: v2\nname: example\nversion: 0.1.0\n",
				"values.yaml": "replicaCount: 1\nimage: {}\n",
				"templates/cm.yaml": "apiVersion: v1\nkind: ConfigMap\nmetadata:\n  name: example\ndata:\n" +
					"  replicas: {{ .Values.replicaCount | quote }}\n  tag: {{ .Values.image.tag | quote }}\n" +
					"  repository: {{ .Values.image.repository | quote }}\n",
			}
			for name, content := range files {
				require.NoError(t, os.WriteFile(filepath.Join(chart, filepath.FromSlash(name)), []byte(content), 0600))
			}
			require.NoError(t, os.WriteFile(filepath.Join(dir, "common.yaml"), []byte("image:\n  repository: example\n"), 0600))
			configPath := filepath.Join(dir, "settings."+format)
			require.NoError(t, os.WriteFile(configPath, []byte(body), 0600))
			cmd := helmTestCommand(t, "--config", configPath, "--helm-set", "replicaCount=3")
			require.NoError(t, initializeConfig(cmd))
			overrides := cmd.Context().Value(helmOverridesKey{}).(*helm.Overrides)
			result, err := (&helm.Resolver{Overrides: overrides}).Resolve(chart)
			require.NoError(t, err)
			require.Len(t, result.File, 1)
			content := string(result.File[0].Content)
			require.Contains(t, content, `replicas: "3"`)
			require.Contains(t, content, `tag: "001"`)
			require.Contains(t, content, `repository: "example"`)
			require.Empty(t, overrides.UnmatchedCharts())
		})
	}
}

func TestHelmInvalidConfigurationFailsBeforeScan(t *testing.T) {
	for i, body := range []string{
		"helm-overrides: null",
		"helm-overrides: []",
		"helm-overrides:\n  global:\n    typo: [image.tag=abc]",
		"helm-overrides:\n  global:\n    set: [123]",
		"helm-overrides:\n  charts:\n    - path: missing-chart\n      set: [image.tag=abc]",
		"helm-overrides:\n  global:\n    values-files: [missing.yaml]",
		"unrecognized-setting: true",
		"helm-set: [image.tag=abc]",
	} {
		t.Run(fmt.Sprint(i), func(t *testing.T) {
			path := filepath.Join(t.TempDir(), "settings.yaml")
			require.NoError(t, os.WriteFile(path, []byte(body), 0600))
			cmd := helmTestCommand(t, "--config", path)
			require.Error(t, initializeConfig(cmd))
		})
	}
}

func TestHelmCLIOnlyAndMalformedSelectors(t *testing.T) {
	cmd := helmTestCommand(t, "--helm-set", "replicaCount=2")
	require.NoError(t, initializeConfig(cmd))
	require.NotNil(t, cmd.Context().Value(helmOverridesKey{}))
	for _, entry := range []string{"chart", "::key=value", "chart::"} {
		cmd := helmTestCommand(t, "--helm-chart-set", entry)
		_, err := helmCLIOverrides(cmd, viper.New())
		require.Error(t, err)
	}
}

func TestHelmEnvironmentExpressionsAreNotCSV(t *testing.T) {
	t.Setenv("KICS_HELM_SET", "items={one,two}")
	cmd := helmTestCommand(t)
	v := viper.New()
	require.NoError(t, flags.BindFlags(cmd, v))
	got, err := cmd.Flags().GetStringArray(flags.HelmSetFlag)
	require.NoError(t, err)
	require.Equal(t, []string{"items={one,two}"}, got)
}

func TestHelmHelpFixture(t *testing.T) {
	cmd := helmTestCommand(t)
	root := NewKICSCmd()
	root.AddCommand(cmd)
	fixture, err := os.ReadFile("../../e2e/fixtures/assets/scan_help")
	require.NoError(t, err)
	// Assert each new flag's exact generated help line, without running the CLI.
	for _, line := range strings.Split(cmd.UsageString(), "\n") {
		if strings.Contains(line, "--helm-") {
			require.Contains(t, string(fixture), line)
		}
	}
}

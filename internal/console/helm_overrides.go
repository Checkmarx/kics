package console

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"strings"

	"github.com/Checkmarx/kics/v2/internal/console/flags"
	"github.com/Checkmarx/kics/v2/pkg/resolver/helm"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

type helmOverridesKey struct{}

func prepareHelmOverrides(cmd *cobra.Command, v *viper.Viper) error {
	if cmd.Flags().Lookup(flags.HelmValuesFlag) == nil {
		return nil
	}
	var config helm.OverrideConfig
	present := v.IsSet("helm-overrides")
	for _, key := range v.AllKeys() {
		// Viper's IsSet/InConfig treat an explicit YAML null as absent.
		present = present || key == "helm-overrides"
	}
	if present {
		data, err := json.Marshal(v.Get("helm-overrides"))
		if err != nil {
			return fmt.Errorf("invalid helm-overrides configuration: %w", err)
		}
		if bytes.Equal(data, []byte("null")) {
			return fmt.Errorf("helm-overrides must be an object")
		}
		decoder := json.NewDecoder(bytes.NewReader(data))
		decoder.DisallowUnknownFields()
		if err := decoder.Decode(&config); err != nil {
			return fmt.Errorf("invalid helm-overrides configuration: %w", err)
		}
	}
	cli, err := helmCLIOverrides(cmd, v)
	if err != nil {
		return err
	}
	workingDir, err := os.Getwd()
	if err != nil {
		return err
	}
	configDir := workingDir
	if v.ConfigFileUsed() != "" {
		configDir = filepath.Dir(v.ConfigFileUsed())
	}
	overrides, err := helm.PrepareOverrides(config, cli, configDir, workingDir)
	if err != nil {
		return err
	}
	ctx := cmd.Context()
	if ctx == nil {
		ctx = context.Background()
	}
	cmd.SetContext(context.WithValue(ctx, helmOverridesKey{}, overrides))
	return nil
}

func helmCLIOverrides(cmd *cobra.Command, v *viper.Viper) (helm.OverrideConfig, error) {
	var cli helm.OverrideConfig
	indices := map[string]int{}
	for _, kind := range []struct {
		global string
		chart  string
		target func(*helm.OverrideValues) *[]string
	}{
		{flags.HelmValuesFlag, flags.HelmChartValuesFlag, func(v *helm.OverrideValues) *[]string { return &v.ValuesFiles }},
		{flags.HelmSetFlag, flags.HelmChartSetFlag, func(v *helm.OverrideValues) *[]string { return &v.Set }},
		{flags.HelmSetStringFlag, flags.HelmChartSetStringFlag, func(v *helm.OverrideValues) *[]string { return &v.SetString }},
	} {
		// Config uses the structured section so its paths retain their origin.
		if v.InConfig(kind.global) || v.InConfig(kind.chart) {
			return cli, fmt.Errorf("use helm-overrides in the configuration file instead of %s or %s", kind.global, kind.chart)
		}
		global, err := cmd.Flags().GetStringArray(kind.global)
		if err != nil {
			return cli, err
		}
		*kind.target(&cli.Global) = global
		entries, err := cmd.Flags().GetStringArray(kind.chart)
		if err != nil {
			return cli, err
		}
		for i, entry := range entries {
			path, value, found := strings.Cut(entry, "::")
			if !found || strings.TrimSpace(path) == "" || strings.TrimSpace(value) == "" {
				return cli, fmt.Errorf("--%s entry %d must use chart-directory::value", kind.chart, i+1)
			}
			index, found := indices[path]
			if !found {
				index = len(cli.Charts)
				indices[path] = index
				cli.Charts = append(cli.Charts, helm.ChartOverrides{Path: path})
			}
			target := kind.target(&cli.Charts[index].OverrideValues)
			*target = append(*target, value)
		}
	}
	return cli, nil
}

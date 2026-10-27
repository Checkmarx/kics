package flags

import (
	"fmt"
	"strings"

	"github.com/pkg/errors"
	"github.com/rs/zerolog/log"
	"github.com/spf13/cobra"
	"github.com/spf13/pflag"
	"github.com/spf13/viper"
)

// FormatNewError reports the impossibility of flag1 and flag2 usage simultaneously
func FormatNewError(flag1, flag2 string) error {
	return errors.Errorf("can't provide '%s' and '%s' flags simultaneously",
		flag1,
		flag2)
}

// ValidateQuerySelectionFlags reports the impossibility of include and exclude flags usage simultaneously
func ValidateQuerySelectionFlags() error {
	if len(GetMultiStrFlag(IncludeQueriesFlag)) > 0 && len(GetMultiStrFlag(ExcludeQueriesFlag)) > 0 {
		return FormatNewError(IncludeQueriesFlag, ExcludeQueriesFlag)
	}
	if len(GetMultiStrFlag(IncludeQueriesFlag)) > 0 && len(GetMultiStrFlag(ExcludeCategoriesFlag)) > 0 {
		return FormatNewError(IncludeQueriesFlag, ExcludeCategoriesFlag)
	}
	return nil
}

// ValidateTypeSelectionFlags reports the impossibility of include and exclude flags usage simultaneously
func ValidateTypeSelectionFlags() error {
	if len(GetMultiStrFlag(TypeFlag)) > 1 && len(GetMultiStrFlag(ExcludeTypeFlag)) > 1 {
		return FormatNewError(TypeFlag, ExcludeTypeFlag)
	}
	if GetMultiStrFlag(TypeFlag)[0] != "" && GetMultiStrFlag(ExcludeTypeFlag)[0] != "" {
		return FormatNewError(TypeFlag, ExcludeTypeFlag)
	}
	return nil
}

// BindFlags fill flags values with config file or environment variables data
func BindFlags(cmd *cobra.Command, v *viper.Viper, sections ...string) error {
	log.Debug().Msg("console.bindFlags()")
	settingsMap := v.AllSettings()
	for _, section := range sections {
		delete(settingsMap, section)
	}
	var bindErr error
	cmd.Flags().VisitAll(func(f *pflag.Flag) {
		settingsMap[f.Name] = true
		if strings.Contains(f.Name, "-") {
			envVarSuffix := strings.ToUpper(strings.ReplaceAll(f.Name, "-", "_"))
			variableName := fmt.Sprintf("%s_%s", "KICS", envVarSuffix)
			if err := v.BindEnv(f.Name, variableName); err != nil {
				log.Err(err).Msg("Failed to bind Viper flags")
			}
		}
		if !f.Changed && v.IsSet(f.Name) {
			val := v.Get(f.Name)
			if err := setBoundFlags(f.Name, val, cmd); err != nil && bindErr == nil {
				bindErr = err
			}
		}
	})
	if bindErr != nil {
		return bindErr
	}
	for key, val := range settingsMap {
		if val != true {
			return fmt.Errorf("unknown configuration key: '%s'\nShowing help for '%s' command", key, cmd.Name())
		}
	}
	return nil
}

func setBoundFlags(flagName string, val interface{}, cmd *cobra.Command) error {
	if flag := cmd.Flags().Lookup(flagName); flag.Value.Type() == "stringArray" {
		var items []string
		switch value := val.(type) {
		case string:
			items = []string{value}
		case []string:
			items = value
		case []interface{}:
			for _, item := range value {
				text, ok := item.(string)
				if !ok {
					return fmt.Errorf("%s must contain strings", flagName)
				}
				items = append(items, text)
			}
		default:
			return fmt.Errorf("%s must be a string or list of strings", flagName)
		}
		// Preserve commas inside Helm expressions; they are not CSV flags.
		if err := flag.Value.(pflag.SliceValue).Replace(items); err != nil {
			return err
		}
		flag.Changed = true
		return nil
	}
	switch t := val.(type) {
	case []interface{}:
		var paramSlice []string
		for _, param := range t {
			text, ok := param.(string)
			if !ok {
				return fmt.Errorf("%s must contain strings", flagName)
			}
			paramSlice = append(paramSlice, text)
		}
		valStr := strings.Join(paramSlice, ",")
		return cmd.Flags().Set(flagName, valStr)
	default:
		return cmd.Flags().Set(flagName, fmt.Sprintf("%v", val))
	}
}

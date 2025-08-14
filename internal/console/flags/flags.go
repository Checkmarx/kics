package flags

import (
	"encoding/json"
	"regexp"
	"strconv"
	"strings"

	"github.com/Checkmarx/kics/v2/internal/console/helpers"
	"github.com/Checkmarx/kics/v2/internal/constants"
	"github.com/rs/zerolog/log"
	"github.com/spf13/cobra"
	"github.com/spf13/pflag"
)

var (
	flagsMultiStrReferences = make(map[string]*[]string)
	flagsStrReferences      = make(map[string]*string)
	flagsBoolReferences     = make(map[string]*bool)
	flagsIntReferences      = make(map[string]*int)

	validations = make(map[string][]string)
)

type flagJSON struct {
	FlagType       string
	ShorthandFlag  string
	DefaultValue   *string
	Usage          string
	Hidden         bool
	Deprecated     bool
	DeprecatedInfo string
	Validation     string
}

func evalUsage(usage string, supportedPlatforms, supportedCloudProviders []string) string {
	variables := map[string]string{
		"sliceInstructions":  "can be provided multiple times or as a comma separated string",
		"supportedLogLevels": strings.Join(constants.AvailableLogLevels, ","),
		"supportedPlatforms": strings.Join(supportedPlatforms, ","),
		"supportedProviders": strings.Join(supportedCloudProviders, ","),
		"supportedReports":   strings.Join(append([]string{"all"}, helpers.ListReportFormats()...), ","),
		"defaultLogFile":     constants.DefaultLogFile,
		"logFormatPretty":    constants.LogFormatPretty,
		"logFormatJSON":      constants.LogFormatJSON,
	}
	variableRegex := regexp.MustCompile(`\$\{(\w+)\}`)
	match := variableRegex.FindAllStringSubmatch(usage, -1)
	for i := range match {
		usage = strings.ReplaceAll(usage, "${"+match[i][1]+"}", variables[match[i][1]])
	}
	return usage
}

func checkHiddenAndDeprecated(flagSet *pflag.FlagSet, flagName string, flagProps flagJSON) error { //nolint:gocritic
	if flagProps.Hidden {
		err := flagSet.MarkHidden(flagName)
		if err != nil {
			log.Err(err).Msg("Loading flags: could not mark flag as hidden")
			return err
		}
	}
	if flagProps.Deprecated {
		err := flagSet.MarkDeprecated(flagName, flagProps.DeprecatedInfo)
		if err != nil {
			log.Err(err).Msg("Loading flags: could not mark flag as deprecated")
			return err
		}
	}
	return nil
}

// InitJSONFlags initialize cobra flags
func InitJSONFlags(
	cmd *cobra.Command,
	flagsListContent string,
	persistentFlag bool,
	supportedPlatforms,
	supportedCloudProviders []string) error {
	var flagsList map[string]flagJSON
	err := json.Unmarshal([]byte(flagsListContent), &flagsList)
	if err != nil {
		log.Err(err).Msg("Loading flags: could not unmarshal flags")
		return err
	}

	flagSet := cmd.Flags()
	if persistentFlag {
		flagSet = cmd.PersistentFlags()
	}

	for flagName, flagProps := range flagsList {
		flagProps.Usage = evalUsage(flagProps.Usage, supportedPlatforms, supportedCloudProviders)

		switch flagProps.FlagType {
		case "multiStr":
			var flag []string
			flagsMultiStrReferences[flagName] = &flag
			defaultValues := make([]string, 0)
			if flagProps.DefaultValue != nil {
				defaultValues = strings.Split(*flagProps.DefaultValue, ",")
			}
			flagSet.StringSliceVarP(flagsMultiStrReferences[flagName], flagName, flagProps.ShorthandFlag, defaultValues, flagProps.Usage)
		case "str":
			var flag string
			flagsStrReferences[flagName] = &flag
			flagSet.StringVarP(flagsStrReferences[flagName], flagName, flagProps.ShorthandFlag, *flagProps.DefaultValue, flagProps.Usage)
		case "bool":
			var flag bool
			flagsBoolReferences[flagName] = &flag
			defaultValue, err := strconv.ParseBool(*flagProps.DefaultValue)
			if err != nil {
				log.Err(err).Msg("Loading flags: could not convert default values")
				return err
			}
			flagSet.BoolVarP(flagsBoolReferences[flagName], flagName, flagProps.ShorthandFlag, defaultValue, flagProps.Usage)
		case "int":
			var flag int
			flagsIntReferences[flagName] = &flag
			defaultValue, err := strconv.Atoi(*flagProps.DefaultValue)
			if err != nil {
				log.Err(err).Msg("Loading flags: could not convert default values")
				return err
			}
			flagSet.IntVarP(flagsIntReferences[flagName], flagName, flagProps.ShorthandFlag, defaultValue, flagProps.Usage)
		default:
			log.Error().Msgf("Flag %s has unknown type %s", flagName, flagProps.FlagType)
		}

		err := checkHiddenAndDeprecated(flagSet, flagName, flagProps)
		if err != nil {
			return err
		}

		if flagProps.Validation != "" {
			validations[flagName] = strings.Split(flagProps.Validation, ",")
		}
	}
	return nil
}

// GetStrFlag get a string flag by its name
func GetStrFlag(flagName string) string {
	if value, ok := flagsStrReferences[flagName]; ok {
		return *value
	}
	log.Debug().Msgf("Could not find string flag %s", flagName)
	return ""
}

// GetMultiStrFlag get a slice of strings flag by its name
func GetMultiStrFlag(flagName string) []string {
	if value, ok := flagsMultiStrReferences[flagName]; ok {
		return *value
	}
	log.Debug().Msgf("Could not find string slice flag %s", flagName)
	return []string{}
}

// GetBoolFlag get a boolean flag by its name
func GetBoolFlag(flagName string) bool {
	if value, ok := flagsBoolReferences[flagName]; ok {
		return *value
	}
	log.Debug().Msgf("Could not find boolean flag %s", flagName)
	return false
}

// GetIntFlag get a integer flag by its name
func GetIntFlag(flagName string) int {
	if value, ok := flagsIntReferences[flagName]; ok {
		return *value
	}
	log.Debug().Msgf("Could not find integer flag %s", flagName)
	return -1
}

// SetStrFlag set a string flag using its name
func SetStrFlag(flagName, value string) {
	if _, ok := flagsStrReferences[flagName]; ok {
		*flagsStrReferences[flagName] = value
	} else {
		log.Debug().Msgf("Could not set string flag %s", flagName)
	}
}

// SetMultiStrFlag set a slice of strings flag using its name
func SetMultiStrFlag(flagName string, value []string) {
	if _, ok := flagsMultiStrReferences[flagName]; ok {
		*flagsMultiStrReferences[flagName] = value
	} else {
		log.Debug().Msgf("Could not set string slice flag %s", flagName)
	}
}

// GetAllFlags returns all flags values
func GetAllFlags() map[string]interface{} {
	flags := make(map[string]interface{})
	for flag, value := range flagsBoolReferences {
		flags[flag] = value
	}
	for flag, value := range flagsIntReferences {
		flags[flag] = value
	}
	for flag, value := range flagsMultiStrReferences {
		flags[flag] = value
	}
	for flag, value := range flagsStrReferences {
		flags[flag] = value
	}

	return flags
}

package console

import (
	_ "embed" // Embed json flags
	"encoding/json"
	"regexp"
	"strconv"
	"strings"

	"github.com/Checkmarx/kics/pkg/engine/source"
	"github.com/rs/zerolog/log"
	"github.com/spf13/cobra"
)

var (
	//go:embed assets/flags.json
	flagsListContent string

	flagsMultiStrReferences map[string]*[]string
	flagsStrReferences      map[string]*string
	flagsBoolReferences     map[string]*bool
	flagsIntReferences      map[string]*int
)

const (
	cloudProviderFlag     = "cloud-provider"
	configFlag            = "config"
	disableCISDescFlag    = "disable-cis-descriptions"
	excludeCategoriesFlag = "exclude-categories"
	excludePathsFlag      = "exclude-paths"
	excludeQueriesFlag    = "exclude-queries"
	excludeResultsFlag    = "exclude-results"
	includeQueriesFlag    = "include-queries"
	inputDataFlag         = "input-data"
	failOnFlag            = "fail-on"
	ignoreOnExitFlag      = "ignore-on-exit"
	minimalUIFlag         = "minimal-ui"
	noProgressFlag        = "no-progress"
	outputNameFlag        = "output-name"
	outputPathFlag        = "output-path"
	pathFlag              = "path"
	payloadPathFlag       = "payload-path"
	previewLinesFlag      = "preview-lines"
	queriesPath           = "queries-path"
	reportFormatsFlag     = "report-formats"
	typeFlag              = "type"
	queryExecTimeoutFlag  = "timeout"
)

type flagsJSON struct {
	FlagType      string
	ShorthandFlag string
	DefaultValue  *string
	Usage         string
}

func getStrFlag(flagName string) string {
	if value, ok := flagsStrReferences[flagName]; ok {
		return *value
	}
	log.Debug().Msgf("Could not find string flag %s", flagName)
	return ""
}

func getMultiStrFlag(flagName string) []string {
	if value, ok := flagsMultiStrReferences[flagName]; ok {
		return *value
	}
	log.Debug().Msgf("Could not find string slice flag %s", flagName)
	return []string{}
}

func getBoolFlag(flagName string) bool {
	if value, ok := flagsBoolReferences[flagName]; ok {
		return *value
	}
	log.Debug().Msgf("Could not find boolean flag %s", flagName)
	return false
}

func getIntFlag(flagName string) int {
	if value, ok := flagsIntReferences[flagName]; ok {
		return *value
	}
	log.Debug().Msgf("Could not find integer flag %s", flagName)
	return -1
}

func setStrFlag(flagName, value string) {
	if _, ok := flagsStrReferences[flagName]; ok {
		*flagsStrReferences[flagName] = value
	} else {
		log.Debug().Msgf("Could not set string flag %s", flagName)
	}
}

func setMultiStrFlag(flagName string, value []string) {
	if _, ok := flagsMultiStrReferences[flagName]; ok {
		*flagsMultiStrReferences[flagName] = value
	} else {
		log.Debug().Msgf("Could not set string slice flag %s", flagName)
	}
}

func evalUsage(usage string) string {
	variables := map[string]string{
		"sliceInstructions":  "can be provided multiple times or as a comma separated string",
		"supportedPlatforms": strings.Join(source.ListSupportedPlatforms(), ", "),
		"supportedProviders": strings.Join(source.ListSupportedCloudProviders(), ", "),
	}
	variableRegex := regexp.MustCompile(`\$\{(\w+)\}`)
	match := variableRegex.FindAllStringSubmatch(usage, -1)
	for i := range match {
		usage = strings.ReplaceAll(usage, "${"+match[i][1]+"}", variables[match[i][1]])
	}
	return usage
}

func initJSONFlags(scanCmd *cobra.Command) error {
	flagsMultiStrReferences = make(map[string]*[]string)
	flagsStrReferences = make(map[string]*string)
	flagsBoolReferences = make(map[string]*bool)
	flagsIntReferences = make(map[string]*int)

	var flagsList map[string]flagsJSON
	err := json.Unmarshal([]byte(flagsListContent), &flagsList)
	if err != nil {
		log.Err(err).Msg("Loading flags: could not unmarshal flags")
		return err
	}

	for flagName, flagProps := range flagsList {
		flagProps.Usage = evalUsage(flagProps.Usage)

		switch flagProps.FlagType {
		case "multiStr":
			var flag []string
			flagsMultiStrReferences[flagName] = &flag
			defaultValues := make([]string, 0)
			if flagProps.DefaultValue != nil {
				defaultValues = strings.Split(*flagProps.DefaultValue, ",")
			}
			scanCmd.Flags().StringSliceVarP(flagsMultiStrReferences[flagName], flagName, flagProps.ShorthandFlag, defaultValues, flagProps.Usage)
		case "str":
			var flag string
			flagsStrReferences[flagName] = &flag
			scanCmd.Flags().StringVarP(flagsStrReferences[flagName], flagName, flagProps.ShorthandFlag, *flagProps.DefaultValue, flagProps.Usage)
		case "bool":
			var flag bool
			flagsBoolReferences[flagName] = &flag
			defaultValue, err := strconv.ParseBool(*flagProps.DefaultValue)
			if err != nil {
				log.Err(err).Msg("Loading flags: could not convert default values")
				return err
			}
			scanCmd.Flags().BoolVarP(flagsBoolReferences[flagName], flagName, flagProps.ShorthandFlag, defaultValue, flagProps.Usage)
		case "int":
			var flag int
			flagsIntReferences[flagName] = &flag
			defaultValue, err := strconv.Atoi(*flagProps.DefaultValue)
			if err != nil {
				log.Err(err).Msg("Loading flags: could not convert default values")
				return err
			}
			scanCmd.Flags().IntVarP(flagsIntReferences[flagName], flagName, flagProps.ShorthandFlag, defaultValue, flagProps.Usage)
		}
	}
	return nil
}

package flags

import (
	"fmt"
	"regexp"
	"runtime"
	"strings"
	"time"

	"github.com/Checkmarx/kics/v2/internal/console/helpers"
	"github.com/Checkmarx/kics/v2/internal/constants"
	"github.com/Checkmarx/kics/v2/pkg/utils"
)

var validMultiStrEnums = map[string]map[string]string{
	CloudProviderFlag:     constants.AvailableCloudProviders,
	ExcludeCategoriesFlag: constants.AvailableCategories,
	ExcludeSeveritiesFlag: convertSliceToDummyMap(constants.AvailableSeverities),
	FailOnFlag:            convertSliceToDummyMap(constants.AvailableSeverities),
	ReportFormatsFlag:     convertSliceToDummyMap(append([]string{"all"}, helpers.ListReportFormats()...)),
	TypeFlag:              constants.AvailablePlatforms,
	ExcludeTypeFlag:       constants.AvailablePlatforms,
}

func sliceFlagsShouldNotStartWithFlags(flagName string) error {
	values := GetMultiStrFlag(flagName)
	re := regexp.MustCompile(`^--[a-z-]+$`)
	if len(values) > 0 {
		firstArg := values[0]
		if strings.HasPrefix(firstArg, "-") && len(firstArg) == 2 || re.MatchString(firstArg) {
			return fmt.Errorf("flag needs an argument: %s", flagName)
		}
	}
	return nil
}

func allQueriesID(flagName string) error {
	queriesID := GetMultiStrFlag(flagName)
	for _, queryID := range queriesID {
		if !isQueryID(queryID) {
			return fmt.Errorf("invalid argument --%s: %s is not a valid query ID", flagName, queryID)
		}
	}
	return nil
}

func validateMultiStrEnum(flagName string) error {
	enums := GetMultiStrFlag(flagName)
	invalidEnum := make([]string, 0)
	caseInsensitiveMap := make(map[string]string)
	for key, value := range validMultiStrEnums[flagName] {
		caseInsensitiveMap[strings.ToLower(key)] = value
	}
	for _, enum := range enums {
		if _, ok := caseInsensitiveMap[strings.ToLower(enum)]; enum != "" && !ok {
			invalidEnum = append(invalidEnum, enum)
		}
	}
	validEnumsValues := utils.SortedKeys(validMultiStrEnums[flagName])
	if len(invalidEnum) > 0 {
		return fmt.Errorf(
			"unknown argument(s) for --%s: %s\nvalid arguments:\n  %s",
			flagName,
			strings.Join(invalidEnum, ", "),
			strings.Join(validEnumsValues, "\n  "),
		)
	}
	return nil
}

func validateWorkersFlag(flagName string) error {
	workers := GetIntFlag(flagName)
	if workers < 0 {
		return fmt.Errorf("invalid argument --%s: value must be greater or equal to 0", flagName)
	}
	if workers > runtime.GOMAXPROCS(-1) {
		now := time.Now()
		timeStr := now.Format("03:04PM")
		fmt.Println("\x1b[90m" + timeStr + " \x1b[31mWRN\x1b[0m Number of workers is greater than the number of logical CPUs")
		return nil
	}
	return nil
}

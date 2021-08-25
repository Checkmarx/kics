package flags

import (
	"fmt"
	"regexp"
	"strings"

	"github.com/Checkmarx/kics/internal/console/helpers"
	"github.com/Checkmarx/kics/internal/constants"
	"github.com/Checkmarx/kics/pkg/utils"
)

var validMultiStrEnums = map[string]map[string]string{
	"cloud-provider":     constants.AvailableCloudProviders,
	"exclude-categories": constants.AvailableCategories,
	"fail-on":            convertSliceToDummyMap(constants.AvailableSeverities),
	"report-formats":     convertSliceToDummyMap(append([]string{"all"}, helpers.ListReportFormats()...)),
	"type":               constants.AvailablePlatforms,
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

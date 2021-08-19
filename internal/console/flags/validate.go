package flags

import (
	"fmt"
	"regexp"
	"strings"

	"github.com/Checkmarx/kics/internal/constants"
	"github.com/Checkmarx/kics/pkg/utils"
)

type flagValidationFuncsMap map[string]func(flagName string) error

var flagValidationFuncs = flagValidationFuncsMap{
	"sliceFlagsShouldNotStartWithFlags": sliceFlagsShouldNotStartWithFlags,
	"validateEnum":                      validateEnum,
}

var validEnums = map[string]map[string]string{
	"cloud-provider":     constants.AvailableCloudProviders,
	"exclude-categories": constants.AvailableCategories,
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

func validateEnum(flagName string) error {
	enums := GetMultiStrFlag(flagName)
	invalidEnum := make([]string, 0)
	caseInsensitiveMap := make(map[string]string)
	for key, value := range validEnums[flagName] {
		caseInsensitiveMap[strings.ToLower(key)] = value
	}
	for _, enum := range enums {
		if _, ok := caseInsensitiveMap[strings.ToLower(enum)]; enum != "" && !ok {
			invalidEnum = append(invalidEnum, enum)
		}
	}
	validEnumsValues := utils.SortedKeys(validEnums[flagName])
	if len(invalidEnum) > 0 {
		return fmt.Errorf(
			"unknown argument for --%s: %s\nvalid arguments:\n  %s",
			flagName,
			strings.Join(invalidEnum, ", "),
			strings.Join(validEnumsValues, "\n  "),
		)
	}
	return nil
}

// Validate validate if flag values are ok, if not, returns an error
func Validate() error {
	for validation, validationFuncs := range validations {
		for _, validationFunc := range validationFuncs {
			if function, ok := flagValidationFuncs[validationFunc]; ok {
				if err := function(validation); err != nil {
					return err
				}
			}
		}
	}
	return nil
}

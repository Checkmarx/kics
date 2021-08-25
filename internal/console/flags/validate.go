package flags

import "regexp"

type flagValidationFuncsMap map[string]func(flagName string) error

var flagValidationFuncs = flagValidationFuncsMap{
	"sliceFlagsShouldNotStartWithFlags": sliceFlagsShouldNotStartWithFlags,
	"validateMultiStrEnum":              validateMultiStrEnum,
	"validateStrEnum":                   validateStrEnum,
	"allQueriesID":                      allQueriesID,
}

func isQueryID(id string) bool {
	re := regexp.MustCompile(`^[0-9a-fA-F]{8}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{12}$`)
	return re.MatchString(id)
}

func convertSliceToDummyMap(slice []string) map[string]string {
	returnMap := make(map[string]string, len(slice))
	for _, element := range slice {
		returnMap[element] = ""
	}
	return returnMap
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

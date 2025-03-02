package flags

import "regexp"

type flagValidationFuncsMap map[string]func(flagName string) error

var flagValidationFuncs = flagValidationFuncsMap{
	"sliceFlagsShouldNotStartWithFlags": sliceFlagsShouldNotStartWithFlags,
	"validateMultiStrEnum":              validateMultiStrEnum,
	"validateStrEnum":                   validateStrEnum,
	"allQueriesID":                      allQueriesID,
	"validateWorkersFlag":               validateWorkersFlag,
	"validatePath":                      validatePath,
}

func isQueryID(id string) bool {
	uuidRegex := regexp.MustCompile(`^[0-9a-fA-F]{8}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{12}$`)
	isQueryID := uuidRegex.MatchString(id)
	if !isQueryID {
		// (t:|p:|a:) matches strings starting with 't:', 'p:', or 'a:'
		// (\d{1,20}) ensures the numeric part has 1 to 20 digits (uint64 validation)
		cxoneRegex := regexp.MustCompile(`^(t:|p:|a:)(\d{1,20})$`)
		isQueryID = cxoneRegex.MatchString(id)
	}
	return isQueryID
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

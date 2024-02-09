package flags

import (
	"errors"
	"regexp"
)

func validatePath(flagName string) error {
	regex := regexp.MustCompile(`[<>"|?*]`)

	isValid := !regex.MatchString(GetStrFlag(flagName))

	if !isValid {
		return errors.New("the directory name contains invalid characters")
	}

	return nil
}

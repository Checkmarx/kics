package flags

import (
	"errors"
	"regexp"
)

func validatePath(flagName string) error {
	regex := regexp.MustCompile(`^(?:\.\.\\|\.\\|\.\.\/|\.\/|\\|\/)?(?:[^<>:"\/\\|?*]+[\\|\/])*[^<>:"\/\\|?*]+$|^[a-zA-Z]:[\\|\/](?:[^<>:"\/\\|?*]+[\\|\/])*[^<>:"\/\\|?*]+$`)

	path := GetStrFlag(flagName)
	isValid := regex.MatchString(path) || path == ""

	if !isValid {
		return errors.New("the directory name contains invalid characters")
	}

	return nil
}

package flags

import (
	"errors"
	"regexp"
)

func validatePath(flagName string) error {
	relPath := `^(?:\.\.\\|\.\\|\.\.\/|\.\/|\\|\/)?(?:[^<>:"\/\\|?*]+[\\\/])*[^<>:"\/\\|?*]+(\/|\\)?$`
	absPath := `^[a-zA-Z]:[\\\/](?:[^<>:"\/\\|?*]+[\\\/])*[^<>:"\/\\|?*]+(?:\/|\\)?$`
	regex := regexp.MustCompile(relPath + `|` + absPath)

	path := GetStrFlag(flagName)
	isValid := regex.MatchString(path) || path == ""

	if !isValid {
		errorMsg := "the directory name you provided for the " + flagName + " flag contains invalid characters"
		return errors.New(errorMsg)
	}

	return nil
}

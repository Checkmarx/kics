package flags

import (
	"errors"
	"regexp"
)

func validatePath(flagName string) error {
	relPath := `^(?:\.\.\\|\.\\|\.\.\/|\.\/|\\|\/)?(?:[^<>:"\/\\|?*]+[\\|\/])*[^<>:"\/\\|?*]+(\/|\\)?$`
	absPath := `^[a-zA-Z]:[\\|\/](?:[^<>:"\/\\|?*]+[\\|\/])*[^<>:"\/\\|?*]+(?:\/|\\)?$`
	regex := regexp.MustCompile(relPath + `|` + absPath)

	path := GetStrFlag(flagName)
	isValid := regex.MatchString(path) || path == ""

	if !isValid {
		return errors.New("the directory name contains invalid characters")
	}

	return nil
}

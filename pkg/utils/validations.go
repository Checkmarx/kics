// Package utils contains various utility functions to use in other packages
package utils

import "regexp"

// ValidateUUID checks if the given id is valid by the format UUID using regex expression
func ValidateUUID(id string) bool {
	uuidRegex := "^[0-9a-fA-F]{8}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{12}$"
	if matched, _ := regexp.MatchString(uuidRegex, id); matched {
		return true
	}
	return false
}

package utils

import (
	"reflect"
	"strings"
)

// Contains if a function to check if list contains target
func Contains(target, list interface{}) bool {
	listVal := reflect.ValueOf(list)

	if listVal.Kind() == reflect.Slice || listVal.Kind() == reflect.Array {
		for i := 0; i < listVal.Len(); i++ {
			if listVal.Index(i).Interface() == target {
				return true
			}
		}
	}

	return false
}

// ContainsInString verifies if some string in list contains the specified target
func ContainsInString(target string, list []string) bool {
	for i := 0; i < len(list); i++ {
		if strings.Contains(list[i], target) {
			return true
		}
	}
	return false
}

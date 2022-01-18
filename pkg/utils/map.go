package utils

import "sort"

// SortedKeys returns a sorted slice with all map keys
func SortedKeys(mapToSort map[string]string) []string {
	keys := make([]string, 0, len(mapToSort))
	for k := range mapToSort {
		keys = append(keys, k)
	}
	sort.Strings(keys)
	return keys
}

// MergeMaps merges two maps
func MergeMaps(map1, map2 map[string]interface{}) {
	for key, value := range map2 {
		map1[key] = value
	}
}

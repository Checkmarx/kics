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

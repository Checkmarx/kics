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

// SafeAddToSliceMap safely adds a value to a slice in a map, initializing the slice if needed
// K is the key type (must be comparable), V is the value type
func SafeAddToSliceMap[K comparable, V any](sliceMap map[K][]V, key K, value V) {
	if sliceMap == nil {
		return
	}
	sliceMap[key] = append(sliceMap[key], value)
}

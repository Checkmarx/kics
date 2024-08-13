/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache-2.0 License.
 *
 * This product includes software developed at Datadog (https://www.datadoghq.com)  Copyright 2024 Datadog, Inc.
 */
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

package utils

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestMap_SortedKeys(t *testing.T) {
	tests := []struct {
		name     string
		usage    map[string]string
		expected []string
	}{
		{
			name: "should return keys sorted",
			usage: map[string]string{
				"c": "",
				"a": "",
				"b": "",
			},
			expected: []string{"a", "b", "c"},
		},
	}
	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			got := SortedKeys(test.usage)
			require.Equal(t, test.expected, got)
		})
	}
}

func TestMap_MergeMaps(t *testing.T) {
	tests := []struct {
		name string
		map1 map[string]interface{}
		map2 map[string]interface{}
		want map[string]interface{}
	}{
		{
			name: "should merge second map on the first",
			map1: map[string]interface{}{
				"test": true,
			},
			map2: map[string]interface{}{
				"kics": true,
			},
			want: map[string]interface{}{
				"test": true,
				"kics": true,
			},
		},
	}

	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			MergeMaps(test.map1, test.map2)
			require.Equal(t, test.want, test.map1)
		})
	}
}

func TestMap_SafeAddToSliceMap(t *testing.T) {
	type addOperation struct {
		key   string
		value int
	}

	tests := []struct {
		name       string
		operations []addOperation
		expected   map[string][]int
	}{
		{
			name: "should add single value to new key",
			operations: []addOperation{
				{key: "numbers", value: 1},
			},
			expected: map[string][]int{
				"numbers": {1},
			},
		},
		{
			name: "should add multiple values to same key",
			operations: []addOperation{
				{key: "numbers", value: 1},
				{key: "numbers", value: 2},
				{key: "numbers", value: 3},
			},
			expected: map[string][]int{
				"numbers": {1, 2, 3},
			},
		},
		{
			name: "should add values to different keys",
			operations: []addOperation{
				{key: "numbers", value: 1},
				{key: "numbers", value: 2},
				{key: "other", value: 10},
			},
			expected: map[string][]int{
				"numbers": {1, 2},
				"other":   {10},
			},
		},
		{
			name: "should handle multiple additions to same key",
			operations: []addOperation{
				{key: "counter", value: 1},
				{key: "counter", value: 2},
				{key: "counter", value: 3},
				{key: "counter", value: 4},
				{key: "counter", value: 5},
			},
			expected: map[string][]int{
				"counter": {1, 2, 3, 4, 5},
			},
		},
	}

	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			m := make(map[string][]int)

			for _, op := range test.operations {
				SafeAddToSliceMap(m, op.key, op.value)
			}

			require.Equal(t, test.expected, m)
		})
	}

	t.Run("should not panic with nil map", func(t *testing.T) {
		var m map[string][]int

		require.NotPanics(t, func() {
			SafeAddToSliceMap(m, "key", 42)
		})

		require.Nil(t, m)
	})
}

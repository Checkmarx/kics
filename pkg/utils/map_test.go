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

package flags

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestFlags_isQueryID(t *testing.T) {
	tests := []struct {
		name     string
		id       string
		expected bool
	}{
		{
			name:     "should return that query id is valid",
			id:       "f81d63d2-c5d7-43a4-a5b5-66717a41c895",
			expected: true,
		},
		{
			name:     "should return that query id is invalid",
			id:       "test",
			expected: false,
		},
		{
			name:     "for prefix 't:' should return that query id is valid",
			id:       "t:12345678901234567890",
			expected: true,
		},
		{
			name:     "for prefix 'p:' should return that query id is valid",
			id:       "p:8820143918834007824",
			expected: true,
		},
		{
			name:     "for prefix 'a:' should return that query id is valid",
			id:       "a:8820143918834007824",
			expected: true,
		},
		{
			name:     "should return that query id is invalid because uint exceeds 20 length",
			id:       "t:123456789012345678901",
			expected: false,
		},
	}
	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			got := isQueryID(test.id)
			require.Equal(t, test.expected, got)
		})
	}
}

func TestFlags_convertSliceToDummyMap(t *testing.T) {
	tests := []struct {
		name     string
		slice    []string
		expected map[string]string
	}{
		{
			name:  "should return a dummy map",
			slice: []string{"key1", "key2"},
			expected: map[string]string{
				"key1": "",
				"key2": "",
			},
		},
	}
	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			got := convertSliceToDummyMap(test.slice)
			require.Equal(t, test.expected, got)
		})
	}
}

package utils

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func Test_ValidateUUID(t *testing.T) {
	tests := []struct {
		name     string
		id       string
		expected bool
	}{
		{
			name:     "invalid uuid",
			id:       "73d6b5f2-6990-4e43-8447e47dd1fef9be",
			expected: false,
		},
		{
			name:     "invalid uuid2",
			id:       "73d6b5f2-6990-4e43-8447-e47dd1fef9bedsadsa",
			expected: false,
		},
		{
			name:     "empty uuid",
			id:       "",
			expected: false,
		},
		{
			name:     "valid uuid",
			id:       "73d6b5f2-6990-4e43-8447-e47dd1fef9be",
			expected: true,
		},
	}
	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			got := ValidateUUID(test.id)
			require.Equal(t, test.expected, got)
		})
	}
}

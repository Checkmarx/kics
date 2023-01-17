package utils

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestContains(t *testing.T) {
	tests := []struct {
		name   string
		list   interface{}
		target interface{}
		want   bool
	}{
		{
			name:   "Should return true when target is present on integer slice",
			list:   []int{1, 2, 3, 4, 5, 6, 7},
			target: 5,
			want:   true,
		},
		{
			name:   "Should return true when target is present on string slice",
			list:   []string{"foo", "bar", "slice", "kics"},
			target: "kics",
			want:   true,
		},
		{
			name:   "Should return false when target is not present on string slice",
			list:   []string{"foo", "bar", "slice", "kics"},
			target: "checkmarx",
			want:   false,
		},
		{
			name:   "Should return false when list is not an slice or array",
			list:   1,
			target: "checkmarx",
			want:   false,
		},
	}

	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			got := Contains(test.target, test.list)
			require.Equal(t, test.want, got)
		})
	}
}

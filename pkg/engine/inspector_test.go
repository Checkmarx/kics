package engine

import (
	"context"
	"fmt"
	"testing"

	"github.com/stretchr/testify/require"
)

func TestMapKeyToString(t *testing.T) {
	testCases := []struct {
		payload  interface{}
		expected string
	}{
		{
			payload:  "test",
			expected: "test",
		},
		{
			payload:  123,
			expected: "123",
		},
		{
			payload:  0.123,
			expected: "0.123",
		},
		{
			payload:  false,
			expected: "false",
		},
		{
			payload:  nil,
			expected: "null",
		},
	}

	ctx := QueryContext{
		ctx: context.Background(),
	}
	for i, testCase := range testCases {
		t.Run(fmt.Sprintf("mapKeyToString-%d", i), func(t *testing.T) {
			v, err := mapKeyToString(ctx, map[string]interface{}{"key": testCase.payload}, "key", false)
			require.Nil(t, err)
			require.Equal(t, testCase.expected, *v)
		})
	}
}

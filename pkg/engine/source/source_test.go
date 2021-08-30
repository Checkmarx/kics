package source

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestMergeLibraries(t *testing.T) { //nolint
	tests := []struct {
		name        string
		customLib   string
		embeddedLib string
		expected    string
		errExpected bool
	}{
		{
			name:      "Should return default library",
			customLib: "",
			embeddedLib: `dummy_test(a) {
	a
			}`,
			expected: `dummy_test(a) {
	a
			}`,
			errExpected: false,
		},
		{
			name: "Should return just custom library",
			customLib: `dummy_test(b) {
	b
			}`,
			embeddedLib: `dummy_test(a) {
	a
			}`,
			expected: `dummy_test(b) {
	b
			}
`,
			errExpected: false,
		},
		{
			name: "Should return merged libraries",
			customLib: `other_dummy_test(b) {
	b
			}`,
			embeddedLib: `dummy_test(a) {
	a
			}`,
			expected: `other_dummy_test(b) {
	b
			}
dummy_test(a) {
	a
			}`,
			errExpected: false,
		},
		{
			name: "Should return merged libraries with overwritten functions",
			customLib: `other_dummy_test(b) {
	b
			}
`,
			embeddedLib: `dummy_test(a) {
	a
			}
other_dummy_test(c) {
	c
			}`,
			expected: `other_dummy_test(b) {
	b
			}

dummy_test(a) {
	a
			}
`,
			errExpected: false,
		},
		{
			name: "Should return error since custom lib is invalid",
			customLib: `other_dummy_test(b) {
	b
			`,
			embeddedLib: `dummy_test(a) {
	a
			}`,
			expected:    "",
			errExpected: true,
		},
		{
			name: "Should return error since embedded lib is invalid",
			customLib: `other_dummy_test(b) {
	b
			}`,
			embeddedLib: `dummy_test(a) {
	a
			`,
			expected:    "",
			errExpected: true,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := mergeLibraries(tt.customLib, tt.embeddedLib)
			if tt.errExpected {
				require.Error(t, err)
			} else {
				require.NoError(t, err)
			}
			require.Equal(t, tt.expected, got)
		})
	}
}

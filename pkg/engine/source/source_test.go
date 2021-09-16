package source

import (
	"encoding/json"
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

// TestMergeInputData tests mergeInputData function
func TestMergeInputData(t *testing.T) {
	tests := []struct {
		name        string
		customData  string
		defaultData string
		want        string
	}{
		{
			name:        "Should merge input data strings",
			defaultData: `{"test": "success"}`,
			customData:  `{"test": "merge", "merge": "success"}`,
			want:        `{"test": "merge","merge": "success"}`,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := MergeInputData(tt.defaultData, tt.customData)
			require.NoError(t, err)
			wantJSON := map[string]interface{}{}
			gotJSON := map[string]interface{}{}
			err = json.Unmarshal([]byte(tt.want), &wantJSON)
			require.NoError(t, err)
			err = json.Unmarshal([]byte(got), &gotJSON)
			require.NoError(t, err)
			require.Equal(t, wantJSON, gotJSON)
		})
	}
}

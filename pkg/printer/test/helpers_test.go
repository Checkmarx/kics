package test

import (
	"errors"
	"os"
	"path/filepath"
	"testing"

	"github.com/stretchr/testify/require"
)

func Test_GetCurrentDirName(t *testing.T) {
	tests := []struct {
		name           string
		path           string
		expectedOutput string
	}{
		{
			name:           "path without \"\"",
			path:           filepath.Join("some", "valid", "dir"),
			expectedOutput: "dir",
		},
		{
			name:           "path with \"\"",
			path:           filepath.Join("some", "valid", "dir") + string(os.PathSeparator),
			expectedOutput: "dir",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			v := GetCurrentDirName(tt.path)
			require.Equal(t, tt.expectedOutput, v)
		})
	}

}

func Test_FormatCurrentDirError(t *testing.T) {
	tests := []struct {
		name           string
		value          error
		expectedOutput string
	}{
		{
			name:           "error format test",
			value:          errors.New("some text"),
			expectedOutput: "change path error = some text",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			v := formatCurrentDirError(tt.value)
			require.Equal(t, tt.expectedOutput, v)
		})
	}

}

func Test_ChangeCurrentDir(t *testing.T) {
	tests := []struct {
		name          string
		desiredDir    string
		startDir      string
		expectedError bool
	}{
		{
			name:          "valid change dir",
			startDir:      filepath.Join("fixtures"),
			desiredDir:    "test",
			expectedError: false,
		},
		{
			name:          "valid change dir",
			startDir:      filepath.Join("fixtures", "all_auth_users_get_read_access"),
			desiredDir:    "test",
			expectedError: false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			os.Chdir(tt.startDir)

			v := ChangeCurrentDir(tt.desiredDir)

			if tt.expectedError {
				require.Error(t, v)
			} else {
				require.NoError(t, v)
			}
		})
	}

}

package flags

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestFlags_validatePathEnum(t *testing.T) {
	tests := []struct {
		name      string
		flagName  string
		flagValue string
		wantErr   bool
	}{
		{
			name:      "should execute fine",
			flagName:  "output-path",
			flagValue: "C:/Users/user/files",
			wantErr:   false,
		},
		{
			name:      "should execute fine",
			flagName:  "output-path",
			flagValue: "/file",
			wantErr:   false,
		},
		{
			name:      "should execute fine",
			flagName:  "output-path",
			flagValue: "file",
			wantErr:   false,
		},
		{
			name:      "should execute fine",
			flagName:  "output-path",
			flagValue: "C:\\Users\\user\\.file",
			wantErr:   false,
		},
		{
			name:      "should execute fine",
			flagName:  "output-path",
			flagValue: "/user/files",
			wantErr:   false,
		},
		{
			name:      "should execute fine",
			flagName:  "output-path",
			flagValue: "\\user\\file",
			wantErr:   false,
		},
		{
			name:      "should execute fine",
			flagName:  "output-path",
			flagValue: "user\\file",
			wantErr:   false,
		},
		{
			name:      "should execute fine",
			flagName:  "output-path",
			flagValue: "./user/files",
			wantErr:   false,
		},
		{
			name:      "should execute fine",
			flagName:  "output-path",
			flagValue: "../user/files",
			wantErr:   false,
		},
		{
			name:      "should return an error regarding invalid characters (*)",
			flagName:  "output-path",
			flagValue: "../user/fil*es",
			wantErr:   true,
		},
		{
			name:      "should return an error regarding invalid characters (|)",
			flagName:  "output-path",
			flagValue: "C:/Users/user/files/|",
			wantErr:   true,
		},
		{
			name:      "should return an error regarding invalid characters (\")",
			flagName:  "output-path",
			flagValue: "C:/Users/user/files/\"",
			wantErr:   true,
		},
		{
			name:      "should return an error regarding invalid characters (?)",
			flagName:  "output-path",
			flagValue: "C:/Users/user/files/?",
			wantErr:   true,
		},
		{
			name:      "should return an error regarding invalid characters (?)",
			flagName:  "output-path",
			flagValue: "..\file?",
			wantErr:   true,
		},
		{
			name:      "should return an error regarding invalid characters (>)",
			flagName:  "output-path",
			flagValue: "C:/Users/user/files/>",
			wantErr:   true,
		},
		{
			name:      "should return an error regarding invalid characters (<)",
			flagName:  "output-path",
			flagValue: "C:/Users/user/files/<",
			wantErr:   true,
		},
		{
			name:      "should return an error regarding invalid characters (*)",
			flagName:  "output-path",
			flagValue: "C:/Users/user/files/*",
			wantErr:   true,
		},
		{
			name:      "should return an error regarding invalid characters",
			flagName:  "output-path",
			flagValue: "c:/*<?>*/:??/folder",
			wantErr:   true,
		},
	}
	for _, test := range tests {
		flagsStrReferences[test.flagName] = &test.flagValue
		t.Run(test.name, func(t *testing.T) {
			gotErr := validatePath(test.flagName)
			if !test.wantErr {
				require.NoError(t, gotErr)
			} else {
				require.Error(t, gotErr)
			}
		})
	}
}

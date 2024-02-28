// nolint
package flags

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestFlags_sliceFlagsShouldNotStartWithFlags(t *testing.T) {
	tests := []struct {
		name      string
		flagName  string
		flagValue *[]string
		wantErr   bool
	}{
		{
			name:      "should execute fine",
			flagName:  "include-queries",
			flagValue: &[]string{"f81d63d2-c5d7-43a4-a5b5-66717a41c895", "97707503-a22c-4cd7-b7c0-f088fa7cf830"},
			wantErr:   false,
		},
		{
			name:      "should return an error when the first value is a shorthand",
			flagName:  "include-queries",
			flagValue: &[]string{"-p", "/home/"},
			wantErr:   true,
		},
		{
			name:      "should return an error when the first value is a flag",
			flagName:  "include-queries",
			flagValue: &[]string{"--path", "/home/"},
			wantErr:   true,
		},
	}
	for _, test := range tests {
		flagsMultiStrReferences[test.flagName] = test.flagValue
		t.Run(test.name, func(t *testing.T) {
			gotErr := sliceFlagsShouldNotStartWithFlags(test.flagName)
			if !test.wantErr {
				require.NoError(t, gotErr)
			} else {
				require.Error(t, gotErr)
			}
		})
	}
}

func TestFlags_validateMultiStrEnum(t *testing.T) {
	tests := []struct {
		name      string
		flagName  string
		flagValue *[]string
		wantErr   bool
	}{
		{
			name:      "should execute fine",
			flagName:  "exclude-categories",
			flagValue: &[]string{"Backup"},
			wantErr:   false,
		},
		{
			name:      "should return an error when an invalid enum value",
			flagName:  "exclude-categories",
			flagValue: &[]string{"Backup", "Undefined"},
			wantErr:   true,
		},
		{
			name:      "should execute type selection fine",
			flagName:  "type",
			flagValue: &[]string{"Ansible"},
			wantErr:   false,
		},
		{
			name:      "should return an error when an invalid type enum value",
			flagName:  "exclude-categories",
			flagValue: &[]string{"Ansible", "Terrraform"},
			wantErr:   true,
		},
	}
	for _, test := range tests {
		flagsMultiStrReferences[test.flagName] = test.flagValue
		t.Run(test.name, func(t *testing.T) {
			gotErr := validateMultiStrEnum(test.flagName)
			if !test.wantErr {
				require.NoError(t, gotErr)
			} else {
				require.Error(t, gotErr)
			}
		})
	}
}

func TestFlags_allQueriesID(t *testing.T) {
	tests := []struct {
		name      string
		flagName  string
		flagValue *[]string
		wantErr   bool
	}{
		{
			name:      "should execute fine",
			flagName:  "exclude-queries",
			flagValue: &[]string{"f81d63d2-c5d7-43a4-a5b5-66717a41c895"},
			wantErr:   false,
		},
		{
			name:      "should return an error when an invalid query id value",
			flagName:  "exclude-queries",
			flagValue: &[]string{"f81d63d2-c5d7-43a4-a5b5-66717a41c895", "Undefined"},
			wantErr:   true,
		},
	}
	for _, test := range tests {
		flagsMultiStrReferences[test.flagName] = test.flagValue
		t.Run(test.name, func(t *testing.T) {
			gotErr := allQueriesID(test.flagName)
			if !test.wantErr {
				require.NoError(t, gotErr)
			} else {
				require.Error(t, gotErr)
			}
		})
	}
}

func TestFlags_ValidateWorkersFlag(t *testing.T) {
	tests := []struct {
		name      string
		flagName  string
		flagValue int
		wantErr   bool
	}{
		{
			name:      "should execute fine",
			flagName:  "parallel",
			flagValue: 1,
			wantErr:   false,
		},
		{
			name:      "should execute fine",
			flagName:  "parallel",
			flagValue: 0,
			wantErr:   false,
		},
		{
			name:      "should return an error when an the number of workers is less than 0",
			flagName:  "parallel",
			flagValue: -1,
			wantErr:   true,
		},
	}
	for _, test := range tests {
		flagsIntReferences[test.flagName] = &test.flagValue
		t.Run(test.name, func(t *testing.T) {
			gotErr := validateWorkersFlag(test.flagName)
			if !test.wantErr {
				require.NoError(t, gotErr)
			} else {
				require.Error(t, gotErr)
			}
		})
	}
}

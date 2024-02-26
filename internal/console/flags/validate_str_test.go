package flags

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestFlags_validateStrEnum(t *testing.T) {
	tests := []struct {
		name      string
		flagName  string
		flagValue string
		wantErr   bool
	}{
		{
			name:      "should execute fine",
			flagName:  "log-level",
			flagValue: "TRACE",
			wantErr:   false,
		},
		{
			name:      "should return an error when an invalid enum value",
			flagName:  "log-level",
			flagValue: "Undefined",
			wantErr:   true,
		},
	}
	for _, test := range tests {
		flagsStrReferences[test.flagName] = &test.flagValue
		t.Run(test.name, func(t *testing.T) {
			gotErr := validateStrEnum(test.flagName)
			if !test.wantErr {
				require.NoError(t, gotErr)
			} else {
				require.Error(t, gotErr)
			}
		})
	}
}

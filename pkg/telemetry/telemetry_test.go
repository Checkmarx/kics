package telemetry

import (
	"os"
	"testing"

	"github.com/stretchr/testify/require"
)

func Test_CheckConnection(t *testing.T) {
	tests := []struct {
		name          string
		setVar        bool
		varValue      string
		expectedError bool
	}{
		{
			name:          "no env var set",
			setVar:        false,
			expectedError: true,
		},
		{
			name:          "dummy env var set",
			setVar:        true,
			varValue:      "http://example.com",
			expectedError: false,
		},
		{
			name:          "valid env var set",
			setVar:        true,
			varValue:      "http://kics.io",
			expectedError: false,
		},
	}

	envVarName := "KICS_DESCRIPTIONS_ENDPOINT"

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			os.Unsetenv(envVarName)
			if tt.setVar {
				os.Setenv(envVarName, tt.varValue)
			}
			c := Client{}
			err := c.CheckConnection()
			if tt.expectedError {
				require.Error(t, err)
			} else {
				require.NoError(t, err)
			}
		})
	}
}

package e2e

import (
	"fmt"
	"strings"
	"testing"

	"github.com/stretchr/testify/require"
)

// E2E_CLI_001 - KICS command should display a help text in the CLI when provided with the --help flag and it should describe the available commands plus the global flags
func Test_E2E_CLI_001(t *testing.T) {
	kicsPath := getKICSBinaryPath("")
	actualOutput, err := runCommandAndReturnOutput([]string{kicsPath, "--help"})
	require.NoError(t, err, "Capture output should not yield an error")
	actualLines := strings.Split(actualOutput, "\n")

	expectedOutput, err := readFixture("E2E_CLI_001")
	require.NoError(t, err, "Reading a fixture should not yield an error")
	expectedLines := strings.Split(expectedOutput, "\n")
	for idx := range expectedLines {
		require.Equal(t, expectedLines[idx], actualLines[idx], fmt.Sprintf("Expected output line\n%s is not equal to actual output line\n%s\n line: %d", expectedLines[idx], actualLines[idx], idx))
	}
}

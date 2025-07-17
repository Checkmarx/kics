package constants

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"testing"

	"github.com/stretchr/testify/require"
)

func TestConstants_GetRelease(t *testing.T) {
	got := GetRelease()

	if Version == "development" {
		require.True(t,
			got == "kics@development" || strings.HasPrefix(got, "kics@"),
			"Expected release to be kics@development or kics@<version>, got: %s", got)
	} else {
		expected := fmt.Sprintf("kics@%s", Version)
		require.Equal(t, expected, got)
	}
}

func TestConstants_GetVersion(t *testing.T) {
	got := GetVersion()

	if Version == "development" {
		require.True(t,
			got == "Keeping Infrastructure as Code Secure, version: development" ||
				strings.HasPrefix(got, "Keeping Infrastructure as Code Secure, version: "),
			"Expected version to be development or a valid version string, got: %s", got)
	} else {
		expected := fmt.Sprintf("Keeping Infrastructure as Code Secure, version: %s", Version)
		require.Equal(t, expected, got)
	}
}

func TestConstants_GetDefaultLogPath(t *testing.T) {
	workDir, _ := os.Getwd()
	got, err := GetDefaultLogPath()
	require.NoError(t, err)
	require.Equal(t, filepath.Join(workDir, DefaultLogFile), got)
}

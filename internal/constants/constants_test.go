package constants

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestConstants_GetRelease(t *testing.T) {
	got := GetRelease()
	require.Equal(t, "kics@development", got)
}

func TestConstants_GetVersion(t *testing.T) {
	got := GetVersion()
	require.Equal(t, "Keeping Infrastructure as Code Secure development", got)
}

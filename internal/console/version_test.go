package console

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestVersionCommand(t *testing.T) {
	t.Run("Tests if generates a valid uuid", func(t *testing.T) {
		out, err := captureCommandOutput(versionCmd)

		require.NoError(t, err)
		require.Equal(t, "Keeping Infrastructure as Code Secure v1.1.1\n", out)
	})
}

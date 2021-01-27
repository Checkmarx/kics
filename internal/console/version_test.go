package console

import (
	"fmt"
	"testing"

	"github.com/Checkmarx/kics/test"
	"github.com/stretchr/testify/require"
)

func TestVersionCommand(t *testing.T) {
	t.Run("Tests if prints current version", func(t *testing.T) {
		out, err := test.CaptureCommandOutput(versionCmd, nil)

		require.NoError(t, err)
		require.Equal(t, fmt.Sprintf("%s\n", currentVersion), out)
	})
}

package console

import (
	"regexp"
	"strings"
	"testing"

	"github.com/Checkmarx/kics/test"
	"github.com/stretchr/testify/require"
)

func TestGenerateIDCommand(t *testing.T) {
	t.Run("Tests if generates a valid uuid", func(t *testing.T) {
		validUUID := regexp.MustCompile(test.ValidUUIDRegex)

		out, err := test.CaptureCommandOutput(generateIDCmd, nil)

		require.NoError(t, err)
		require.True(t, validUUID.MatchString(strings.TrimSpace(out)))
	})
}

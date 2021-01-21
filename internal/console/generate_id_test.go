package console

import (
	"bytes"
	"io"
	"os"
	"regexp"
	"strings"
	"testing"

	"github.com/spf13/cobra"
	"github.com/stretchr/testify/require"
)

type execute func() error

func captureOutput(funcToExec execute) (string, error) {
	old := os.Stdout
	r, w, _ := os.Pipe()
	os.Stdout = w

	err := funcToExec()

	outC := make(chan string)

	go func() {
		var buf bytes.Buffer
		io.Copy(&buf, r) // nolint
		outC <- buf.String()
	}()

	w.Close()
	os.Stdout = old
	out := <-outC

	return out, err
}

func captureCommandOutput(cmd *cobra.Command, args []string) (string, error) {
	if len(args) > 0 {
		cmd.SetArgs(args)
	}

	return captureOutput(cmd.Execute)
}

func TestGenerateIDCommand(t *testing.T) {
	t.Run("Tests if generates a valid uuid", func(t *testing.T) {
		validUUID := regexp.MustCompile(`(?i)^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$`)

		out, err := captureCommandOutput(generateIDCmd, nil)

		require.NoError(t, err)
		require.True(t, validUUID.MatchString(strings.TrimSpace(out)))
	})
}

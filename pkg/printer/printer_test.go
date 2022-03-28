package printer

import (
	"os"
	"testing"

	"github.com/Checkmarx/kics/internal/console/flags"
	"github.com/spf13/cobra"
	"github.com/stretchr/testify/require"
)

func TestPrinter_SetupPrinter(t *testing.T) {
	mockCmd := &cobra.Command{
		Use:   "mock",
		Short: "Mock cmd",
		RunE: func(cmd *cobra.Command, args []string) error {
			return nil
		},
	}

	data, _ := os.ReadFile("../assets/kics-flags.json")
	flags.InitJSONFlags(mockCmd, string(data), false, []string{"terraform"}, []string{"aws"})

	err := SetupPrinter(mockCmd.Flags())
	require.NoError(t, err)
	require.True(t, IsInitialized())
}

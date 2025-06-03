package console

import (
	"fmt"

	"github.com/Checkmarx/kics/v2/internal/constants"
	"github.com/spf13/cobra"
)

// NewVersionCmd creates a new instance of the version Command
func NewVersionCmd() *cobra.Command {
	return &cobra.Command{
		Use:   "version",
		Short: "Displays the current version",
		RunE: func(cmd *cobra.Command, args []string) error {
			_, err := fmt.Fprintf(cmd.OutOrStdout(), "%s\n", constants.GetVersion())
			if err != nil {
				return err
			}
			return nil
		},
	}
}

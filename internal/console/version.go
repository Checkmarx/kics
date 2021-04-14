package console

import (
	"fmt"

	"github.com/Checkmarx/kics/internal/constants"
	"github.com/spf13/cobra"
)

func NewVersionCmd() *cobra.Command {
	return &cobra.Command{
		Use:   "version",
		Short: "Displays the current version",
		RunE: func(cmd *cobra.Command, args []string) error {
			fmt.Fprintf(cmd.OutOrStdout(), "%s\n", getVersion())
			return nil
		},
	}
}

func getVersion() string {
	return fmt.Sprintf("%s %s", constants.Fullname, constants.Version)
}

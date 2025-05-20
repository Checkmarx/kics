package console

import (
	"fmt"

	"github.com/Checkmarx/kics/v2/pkg/engine/source"
	"github.com/spf13/cobra"
)

// NewListPlatformsCmd creates a new instance of the list-platforms Command
func NewListPlatformsCmd() *cobra.Command {
	return &cobra.Command{
		Use:   "list-platforms",
		Short: "List supported platforms",
		RunE: func(cmd *cobra.Command, args []string) error {
			for _, v := range source.ListSupportedPlatforms() {
				_, err := fmt.Fprintf(cmd.OutOrStdout(), "%s\n", v)
				if err != nil {
					return err
				}
			}
			return nil
		},
	}
}

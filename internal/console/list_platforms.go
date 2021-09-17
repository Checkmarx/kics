package console

import (
	"fmt"

	"github.com/Checkmarx/kics/pkg/engine/source"
	"github.com/Checkmarx/kics/pkg/utils"
	"github.com/spf13/cobra"
)

// NewListPlatformsCmd creates a new instance of the list-platforms Command
func NewListPlatformsCmd() *cobra.Command {
	return &cobra.Command{
		Use:   "list-platforms",
		Short: "List supported platforms",
		RunE: func(cmd *cobra.Command, args []string) error {
			defer utils.PanicHandler()
			for _, v := range source.ListSupportedPlatforms() {
				fmt.Fprintf(cmd.OutOrStdout(), "%s\n", v)
			}
			return nil
		},
	}
}

package console

import (
	"fmt"

	"github.com/Checkmarx/kics/pkg/engine/source"
	"github.com/spf13/cobra"
)

var listPlatformsCmd = &cobra.Command{
	Use:   "list-platforms",
	Short: "List supported platforms",
	RunE: func(cmd *cobra.Command, args []string) error {
		for _, v := range source.ListSupportedPlatforms() {
			fmt.Println(v)
		}
		return nil
	},
}

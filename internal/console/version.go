package console

import (
	"fmt"

	consoleHelpers "github.com/Checkmarx/kics/internal/console/helpers"
	"github.com/spf13/cobra"
)

var versionCmd = &cobra.Command{
	Use:   "version",
	Short: "Displays the current version",
	RunE: func(cmd *cobra.Command, args []string) error {
		fmt.Printf("%s\n", getVersion())
		return nil
	},
}

func getVersion() string {
	return consoleHelpers.CurrentKICSFullname + " v" + consoleHelpers.CurrentKICSVersion
}

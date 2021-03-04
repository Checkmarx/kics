package console

import (
	"fmt"

	"github.com/spf13/cobra"
)

// Version - current KICS version
var Version = "dev"

var versionCmd = &cobra.Command{
	Use:   "version",
	Short: "Displays the current version",
	RunE: func(cmd *cobra.Command, args []string) error {
		fmt.Printf("%s\n", getVersion())
		return nil
	},
}

func getVersion() string {
	return fmt.Sprintf("Keeping Infrastructure as Code Secure %s", Version)
}

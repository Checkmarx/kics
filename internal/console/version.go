package console

import (
	"fmt"

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
	return "Keeping Infrastructure as Code Secure v1.1.0"
}

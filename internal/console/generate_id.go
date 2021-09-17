package console

import (
	"fmt"

	"github.com/Checkmarx/kics/pkg/utils"
	"github.com/google/uuid"
	"github.com/rs/zerolog/log"
	"github.com/spf13/cobra"
)

// NewGenerateIDCmd creates a new instance of the generate-id Command
func NewGenerateIDCmd() *cobra.Command {
	return &cobra.Command{
		Use:   "generate-id",
		Short: "Generates uuid for query",
		RunE: func(cmd *cobra.Command, args []string) error {
			defer utils.PanicHandler()
			_, err := fmt.Fprintln(cmd.OutOrStdout(), uuid.New().String())
			if err != nil {
				log.Err(err).Msg("failed to get uuid")
			}
			return err
		},
	}
}

package console

import (
	"fmt"

	"github.com/google/uuid"
	"github.com/rs/zerolog/log"
	"github.com/spf13/cobra"
)

func NewGenerateIDCmd() *cobra.Command {
	return &cobra.Command{
		Use:   "generate-id",
		Short: "Generates uuid for query",
		RunE: func(cmd *cobra.Command, args []string) error {
			_, err := fmt.Fprint(cmd.OutOrStdout(), uuid.New().String())
			if err != nil {
				log.Err(err).Msg("failed to get uuid")
			}
			return err
		},
	}
}

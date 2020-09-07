package main

import (
	"context"

	"github.com/checkmarxDev/ice/pkg/engine"
	"github.com/checkmarxDev/ice/pkg/engine/query"
	"github.com/checkmarxDev/ice/pkg/ice"
	"github.com/checkmarxDev/ice/pkg/parser"
	"github.com/checkmarxDev/ice/pkg/source"
	"github.com/checkmarxDev/ice/pkg/storage"
	"github.com/rs/zerolog/log"
	"github.com/spf13/cobra"
)

func main() {
	var (
		path      string
		queryPath string
	)

	ctx := context.Background()

	rootCmd := &cobra.Command{
		Use:   "inspect",
		Short: "Security inspect tool for Terraform files",
		RunE: func(cmd *cobra.Command, args []string) error {
			store := storage.NewMemoryStorage()

			inspector, err := engine.NewInspector(ctx, query.NewFilesystemSource(queryPath), store)
			if err != nil {
				return err
			}

			filesSource := source.NewFilesystemSourceProvider(path)

			service := ice.NewService(
				filesSource,
				store,
				parser.NewDefault(),
				inspector,
			)

			return service.StartScan(ctx, "console scan")
		},
	}

	rootCmd.Flags().StringVarP(&path, "path", "p", "", "file or directory path to inspect")
	rootCmd.Flags().StringVarP(&queryPath, "queries-path", "q", "./assets/queries", "file or directory path to inspect")
	if err := rootCmd.MarkFlagRequired("path"); err != nil {
		log.Err(err).Msg("failed to add command required flags")
	}

	if err := rootCmd.ExecuteContext(ctx); err != nil {
		log.Err(err).Msg("failed to execute main command")
	}
}

package main

import (
	"context"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"

	"github.com/checkmarxDev/ice/internal/storage"
	"github.com/checkmarxDev/ice/pkg/engine"
	"github.com/checkmarxDev/ice/pkg/engine/query"
	"github.com/checkmarxDev/ice/pkg/ice"
	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/checkmarxDev/ice/pkg/parser"
	"github.com/checkmarxDev/ice/pkg/source"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"github.com/spf13/cobra"
)

const scanID = "console"

func main() {
	var (
		path       string
		queryPath  string
		outputPath string
		verbose    bool
	)

	ctx := context.Background()
	if verbose {
		log.Logger = log.Output(zerolog.ConsoleWriter{Out: os.Stdout})
	}

	rootCmd := &cobra.Command{
		Use:   "inspect",
		Short: "Security inspect tool for Terraform files",
		RunE: func(cmd *cobra.Command, args []string) error {
			store := storage.NewMemoryStorage()
			if verbose {
				log.Logger = log.Output(zerolog.ConsoleWriter{Out: os.Stdout})
			} else {
				log.Logger = log.Output(zerolog.ConsoleWriter{Out: ioutil.Discard})
			}

			querySource := &query.FilesystemSource{
				Source: queryPath,
			}

			inspector, err := engine.NewInspector(ctx, querySource, store)
			if err != nil {
				return err
			}

			filesSource := &source.FileSystemSourceProvider{Path: path}

			service := &ice.Service{
				SourceProvider: filesSource,
				Storage:        store,
				Parser:         parser.NewDefault(),
				Inspector:      inspector,
			}

			if scanErr := service.StartScan(ctx, scanID); scanErr != nil {
				return scanErr
			}

			result, err := store.GetResults(ctx, scanID)
			if err != nil {
				return err
			}

			files, err := store.GetFiles(ctx, scanID, "$.")
			if err != nil {
				return err
			}

			summary := model.CreateSummary(files, result)

			if outputPath != "" {
				return printResultToFile(outputPath, summary)
			}

			return printResult(summary)
		},
	}

	rootCmd.Flags().StringVarP(&path, "path", "p", "", "file or directory path to inspect")
	rootCmd.Flags().StringVarP(&queryPath, "queries-path", "q", "./assets/queries", "file or directory path to inspect")
	rootCmd.Flags().StringVarP(&outputPath, "output-path", "o", "", "file to store result in json format")
	rootCmd.Flags().BoolVarP(&verbose, "verbose", "v", false, "verbose scan")
	if err := rootCmd.MarkFlagRequired("path"); err != nil {
		log.Err(err).Msg("failed to add command required flags")
	}

	if err := rootCmd.ExecuteContext(ctx); err != nil {
		log.Err(err).Msg("failed to execute main command")
	}
}

func printResult(summary model.Summary) error {
	fmt.Printf("Scanned files: %d\n", summary.ScannedFiles)
	for _, q := range summary.Queries {
		fmt.Printf("%s, Severity: %s, Results: %d\n", q.QueryName, q.Severity, len(q.Files))
		for _, f := range q.Files {
			fmt.Printf("\t%s:%d\n", f.FileName, f.Line)
		}
	}

	return nil
}

func printResultToFile(path string, summary model.Summary) error {
	f, err := os.OpenFile(path, os.O_WRONLY|os.O_CREATE, os.ModePerm)
	if err != nil {
		return err
	}
	defer func() {
		if err := f.Close(); err != nil {
			log.Err(err).Msgf("failed to close file %s", path)
		}

		log.Info().Str("fileName", path).Msgf("Results saved to file %s", path)
	}()

	encoder := json.NewEncoder(f)
	encoder.SetIndent("", "\t")

	return encoder.Encode(summary)
}

package main

import (
	"context"
	"os"

	console "github.com/Checkmarx/kics/pkg/console"
	"github.com/getsentry/sentry-go"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"github.com/spf13/cobra"
)

func main() { // nolint:funlen,gocyclo
	err := sentry.Init(sentry.ClientOptions{})
	if err != nil {
		log.Err(err).Msg("failed to initialize sentry")
	}

	var (
		path        string
		queryPath   string
		outputPath  string
		payloadPath string
		verbose     bool
		logFile     bool
		generateID  bool
		version     bool
	)

	ctx := context.Background()
	if verbose {
		log.Logger = log.Output(zerolog.ConsoleWriter{Out: os.Stdout})
	}
	zerolog.SetGlobalLevel(zerolog.InfoLevel)

	rootCmd := &cobra.Command{
		Use:   "kics",
		Short: "Keeping Infrastructure as Code Secure",
		RunE: func(cmd *cobra.Command, args []string) error {
			flags := console.InitOptions{
				Path:        path,
				QueryPath:   queryPath,
				OutputPath:  outputPath,
				PayloadPath: payloadPath,
				Verbose:     verbose,
				LogFile:     logFile,
				Version:     version,
			}

			return console.Init(ctx, flags)
		},
	}

	rootCmd.Flags().StringVarP(&path, "path", "p", "", "path to file or directory to scan")
	rootCmd.Flags().StringVarP(&queryPath, "queries-path", "q", "./assets/queries", "path to directory with queries")
	rootCmd.Flags().StringVarP(&outputPath, "output-path", "o", "", "file path to store result in json format")
	rootCmd.Flags().StringVarP(&payloadPath, "payload-path", "d", "", "file path to store source internal representation in JSON format")
	rootCmd.Flags().BoolVarP(&verbose, "verbose", "v", false, "verbose scan")
	rootCmd.Flags().BoolVarP(&logFile, "log-file", "l", false, "log to file info.log")
	rootCmd.Flags().BoolVarP(&generateID, "generate-id", "g", false, "generate uuid for query")
	rootCmd.Flags().BoolVarP(&version, "version", "", false, "Show kics's current version")

	if err := rootCmd.ExecuteContext(ctx); err != nil {
		sentry.CaptureException(err)
		log.Err(err).Msg("failed to run application")
		os.Exit(-1)
	}
}

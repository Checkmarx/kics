package main

import (
	"context"
	"encoding/json"
	"fmt"
	"io"
	"io/ioutil"
	"os"
	"strings"
	"time"

	"github.com/Checkmarx/kics/internal/storage"
	"github.com/Checkmarx/kics/internal/tracker"
	"github.com/Checkmarx/kics/pkg/engine"
	"github.com/Checkmarx/kics/pkg/engine/query"
	"github.com/Checkmarx/kics/pkg/kics"
	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/pkg/parser"
	dockerParser "github.com/Checkmarx/kics/pkg/parser/docker"
	terraformParser "github.com/Checkmarx/kics/pkg/parser/terraform"
	yamlParser "github.com/Checkmarx/kics/pkg/parser/yaml"
	"github.com/Checkmarx/kics/pkg/source"
	"github.com/getsentry/sentry-go"
	"github.com/google/uuid"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"github.com/spf13/cobra"
)

const (
	scanID   = "console"
	timeMult = 2
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
	)

	ctx := context.Background()
	if verbose {
		log.Logger = log.Output(zerolog.ConsoleWriter{Out: os.Stdout})
	}
	zerolog.SetGlobalLevel(zerolog.InfoLevel)

	consoleLogger := zerolog.ConsoleWriter{Out: ioutil.Discard}
	fileLogger := zerolog.ConsoleWriter{Out: ioutil.Discard}

	rootCmd := &cobra.Command{
		Use:   "kics",
		Short: "Keeping Infrastructure as Code Secure",
		RunE: func(cmd *cobra.Command, args []string) error {
			defer sentry.Flush(timeMult * time.Second)

			if verbose {
				consoleLogger = zerolog.ConsoleWriter{Out: os.Stdout}
			}

			if generateID {
				_, err = fmt.Printf(uuid.New().String())
				return err
			}

			if logFile {
				file, err := os.OpenFile("info.log", os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0666)
				if err != nil {
					return err
				}
				fileLogger = customConsoleWriter(&zerolog.ConsoleWriter{Out: file, NoColor: true})
			}

			mw := io.MultiWriter(consoleLogger, fileLogger)
			log.Logger = log.Output(mw)

			querySource := &query.FilesystemSource{
				Source: queryPath,
			}

			t := &tracker.CITracker{}
			inspector, err := engine.NewInspector(ctx, querySource, engine.DefaultVulnerabilityBuilder, t)
			if err != nil {
				return err
			}

			var excludeFiles []string
			if payloadPath != "" {
				excludeFiles = append(excludeFiles, payloadPath)
			}

			filesSource, err := source.NewFileSystemSourceProvider(path, excludeFiles)
			if err != nil {
				return err
			}

			combinedParser := parser.NewBuilder().
				// Add(&jsonParser.Parser{}).
				Add(&yamlParser.Parser{}).
				Add(terraformParser.NewDefault()).
				Add(&dockerParser.Parser{}).
				Build()

			store := storage.NewMemoryStorage()

			service := &kics.Service{
				SourceProvider: filesSource,
				Storage:        store,
				Parser:         combinedParser,
				Inspector:      inspector,
				Tracker:        t,
			}

			if scanErr := service.StartScan(ctx, scanID); scanErr != nil {
				return scanErr
			}

			result, err := store.GetVulnerabilities(ctx, scanID)
			if err != nil {
				return err
			}

			files, err := store.GetFiles(ctx, scanID)
			if err != nil {
				return err
			}

			counters := model.Counters{
				ScannedFiles:           t.FoundFiles,
				ParsedFiles:            t.ParsedFiles,
				TotalQueries:           t.LoadedQueries,
				FailedToExecuteQueries: t.LoadedQueries - t.ExecutedQueries,
			}

			summary := model.CreateSummary(counters, result)

			if payloadPath != "" {
				if err := printToJSONFile(payloadPath, files.Combine()); err != nil {
					return err
				}
			}

			if outputPath != "" {
				if err := printToJSONFile(outputPath, summary); err != nil {
					return err
				}
			}

			if err := printResult(summary); err != nil {
				return err
			}

			if summary.FailedToExecuteQueries > 0 {
				os.Exit(1)
			}

			return nil
		},
	}

	rootCmd.Flags().StringVarP(&path, "path", "p", "", "path to file or directory to scan")
	rootCmd.Flags().StringVarP(&queryPath, "queries-path", "q", "./assets/queries", "path to directory with queries")
	rootCmd.Flags().StringVarP(&outputPath, "output-path", "o", "", "file path to store result in json format")
	rootCmd.Flags().StringVarP(&payloadPath, "payload-path", "d", "", "file path to store source internal representation in JSON format")
	rootCmd.Flags().BoolVarP(&verbose, "verbose", "v", false, "verbose scan")
	rootCmd.Flags().BoolVarP(&logFile, "log-file", "l", false, "log to file info.log")
	rootCmd.Flags().BoolVarP(&generateID, "generate-id", "g", false, "generate uuid for query")

	if err := rootCmd.ExecuteContext(ctx); err != nil {
		sentry.CaptureException(err)
		log.Err(err).Msg("failed to run application")
		os.Exit(-1)
	}
}

func printResult(summary model.Summary) error {
	fmt.Printf("Files scanned: %d\n", summary.ScannedFiles)
	fmt.Printf("Parsed files: %d\n", summary.ParsedFiles)
	fmt.Printf("Queries loaded: %d\n", summary.TotalQueries)
	fmt.Printf("Queries failed to execute: %d\n", summary.FailedToExecuteQueries)
	for _, q := range summary.Queries {
		fmt.Printf("%s, Severity: %s, Results: %d\n", q.QueryName, q.Severity, len(q.Files))
		for _, f := range q.Files {
			fmt.Printf("\t%s:%d\n", f.FileName, f.Line)
		}
	}
	log.
		Info().
		Msgf("\n\nFiles scanned: %d\n"+
			"Parsed files: %d\nQueries loaded: %d\n"+
			"Queries failed to execute: %d\n",
			summary.ScannedFiles, summary.ParsedFiles, summary.TotalQueries, summary.FailedToExecuteQueries)
	log.
		Info().
		Msg("Inspector stopped\n")

	return nil
}

func printToJSONFile(path string, body interface{}) error {
	f, err := os.OpenFile(path, os.O_WRONLY|os.O_CREATE|os.O_TRUNC, os.ModePerm)
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

	return encoder.Encode(body)
}

func customConsoleWriter(fileLogger *zerolog.ConsoleWriter) zerolog.ConsoleWriter {
	fileLogger.FormatLevel = func(i interface{}) string {
		return strings.ToUpper(fmt.Sprintf("| %-6s|", i))
	}

	fileLogger.FormatFieldName = func(i interface{}) string {
		return fmt.Sprintf("%s:", i)
	}

	fileLogger.FormatErrFieldName = func(i interface{}) string {
		return "ERROR:"
	}

	fileLogger.FormatFieldValue = func(i interface{}) string {
		return strings.ToUpper(fmt.Sprintf("%s", i))
	}

	return *fileLogger
}

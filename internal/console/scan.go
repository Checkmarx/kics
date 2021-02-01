package console

import (
	"fmt"
	"io"
	"io/ioutil"
	"os"
	"time"

	consoleHelpers "github.com/Checkmarx/kics/internal/console/helpers"
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
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"github.com/spf13/cobra"
)

var (
	path        string
	queryPath   string
	outputPath  string
	payloadPath string
	verbose     bool
	logFile     bool
	noProgress  bool
)

var scanCmd = &cobra.Command{
	Use:   "scan",
	Short: "Executes a scan analysis",
	RunE: func(cmd *cobra.Command, args []string) error {
		return scan()
	},
}

func initScanCmd() {
	scanCmd.Flags().StringVarP(&path, "path", "p", "", "path to file or directory to scan")
	scanCmd.Flags().StringVarP(&queryPath, "queries-path", "q", "./assets/queries", "path to directory with queries")
	scanCmd.Flags().StringVarP(&outputPath, "output-path", "o", "", "file path to store result in json format")
	scanCmd.Flags().StringVarP(&payloadPath, "payload-path", "d", "", "file path to store source internal representation in JSON format")
	scanCmd.Flags().BoolVarP(&verbose, "verbose", "v", false, "verbose scan")
	scanCmd.Flags().BoolVarP(&logFile, "log-file", "l", false, "log to file info.log")
	scanCmd.Flags().BoolVarP(&noProgress, "no-progress", "", false, "hides scan's progress bar")

	if err := scanCmd.MarkFlagRequired("path"); err != nil {
		sentry.CaptureException(err)
		log.Err(err).Msg("failed to add command required flags")
	}
}

func setupLogs() error {
	consoleLogger := zerolog.ConsoleWriter{Out: ioutil.Discard}
	fileLogger := zerolog.ConsoleWriter{Out: ioutil.Discard}

	if verbose {
		consoleLogger = zerolog.ConsoleWriter{Out: os.Stdout}
	}

	if logFile {
		file, err := os.OpenFile("info.log", os.O_APPEND|os.O_CREATE|os.O_WRONLY, os.ModePerm)
		if err != nil {
			return err
		}
		fileLogger = consoleHelpers.CustomConsoleWriter(&zerolog.ConsoleWriter{Out: file, NoColor: true})
	}

	mw := io.MultiWriter(consoleLogger, fileLogger)
	log.Logger = log.Output(mw)
	return nil
}

func scan() error {
	fmt.Printf("Scanning with %s\n\n", getVersion())

	if err := setupLogs(); err != nil {
		return err
	}

	scanStartTime := time.Now()

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

	if scanErr := service.StartScan(ctx, scanID, noProgress); scanErr != nil {
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

	elapsed := time.Since(scanStartTime)

	counters := model.Counters{
		ScannedFiles:           t.FoundFiles,
		ParsedFiles:            t.ParsedFiles,
		TotalQueries:           t.LoadedQueries,
		FailedToExecuteQueries: t.LoadedQueries - t.ExecutedQueries,
		FailedSimilarityID:     t.FailedSimilarityID,
	}

	summary := model.CreateSummary(counters, result, scanID)

	if err := printJSON(payloadPath, files.Combine()); err != nil {
		return err
	}

	if err := printJSON(outputPath, summary); err != nil {
		return err
	}

	if err := consoleHelpers.PrintResult(&summary, inspector.GetFailedQueries()); err != nil {
		return err
	}

	elapsedStrFormat := "Scan duration: %v\n"
	fmt.Printf(elapsedStrFormat, elapsed)
	log.Info().Msgf(elapsedStrFormat, elapsed)

	if summary.FailedToExecuteQueries > 0 {
		os.Exit(1)
	}

	return nil
}

func printJSON(path string, body interface{}) error {
	if path != "" {
		return consoleHelpers.PrintToJSONFile(path, body)
	}
	return nil
}

package console

import (
	"fmt"
	"io"
	"io/ioutil"
	"os"
	"strings"

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
	exclude     string
	verbose     bool
	logFile     bool
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
	scanCmd.Flags().StringVarP(&exclude, "exclude", "e", "", "exclude paths from analysis")
	scanCmd.Flags().BoolVarP(&verbose, "verbose", "v", false, "verbose scan")
	scanCmd.Flags().BoolVarP(&logFile, "log-file", "l", false, "log to file info.log")

	if err := scanCmd.MarkFlagRequired("path"); err != nil {
		sentry.CaptureException(err)
		log.Err(err).Msg("failed to add command required flags")
	}
}

func scan() error {
	fmt.Printf("Scanning with %s\n\n", getVersion())

	consoleLogger := zerolog.ConsoleWriter{Out: ioutil.Discard}
	fileLogger := zerolog.ConsoleWriter{Out: ioutil.Discard}

	if verbose {
		consoleLogger = zerolog.ConsoleWriter{Out: os.Stdout}
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

	var excludePaths []string
	if payloadPath != "" {
		excludePaths = append(excludePaths, payloadPath)
	}

	if exclude != "" {
		excludePaths = append(excludePaths, strings.Split(exclude, ",")...)
	}

	filesSource, err := source.NewFileSystemSourceProvider(path, excludePaths)
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
		FailedSimilarityID:     t.FailedSimilarityID,
	}

	summary := model.CreateSummary(counters, result, scanID)

	if err := printJSON(payloadPath, files.Combine()); err != nil {
		return err
	}

	if err := printJSON(outputPath, summary); err != nil {
		return err
	}

	if err := printResult(&summary); err != nil {
		return err
	}

	if summary.FailedToExecuteQueries > 0 {
		os.Exit(1)
	}

	return nil
}

func printJSON(path string, body interface{}) error {
	if path != "" {
		return printToJSONFile(path, body)
	}
	return nil
}

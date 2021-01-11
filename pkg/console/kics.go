package console

import (
	"context"
	"fmt"
	"io"
	"io/ioutil"
	"os"
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
)

// InitOptions represents the flags structure
type InitOptions struct {
	Path        string
	QueryPath   string
	OutputPath  string
	PayloadPath string
	Verbose     bool
	LogFile     bool
	GenerateID  bool
	Version     bool
}

type analyseOptions struct {
	path        string
	queryPath   string
	outputPath  string
	payloadPath string
	verbose     bool
	logFile     bool
}

const (
	scanID   = "console"
	timeMult = 2
)

// Init executes kics with the given flags
func Init(ctx context.Context, initArgs InitOptions) error {
	defer sentry.Flush(timeMult * time.Second)

	if initArgs.Version {
		fmt.Printf("%s\n", getVersion())
		return nil
	}

	if initArgs.GenerateID {
		generateID()
		return nil
	}

	analyseArgs := analyseOptions{
		path:        initArgs.Path,
		queryPath:   initArgs.QueryPath,
		outputPath:  initArgs.OutputPath,
		payloadPath: initArgs.PayloadPath,
		verbose:     initArgs.Verbose,
		logFile:     initArgs.LogFile,
	}

	return analyze(ctx, analyseArgs)
}

func getVersion() string {
	return "Keeping Infrastructure as Code Secure v1.1.0"
}

func generateID() {
	_, err := fmt.Println(uuid.New().String())
	if err != nil {
		log.Err(err).Msg("failed to get uuid")
		os.Exit(-1)
	}
	os.Exit(0)
}

func analyze(ctx context.Context, analyseArgs analyseOptions) error {
	fmt.Printf("Starting analysis using %s", getVersion())

	consoleLogger := zerolog.ConsoleWriter{Out: ioutil.Discard}
	fileLogger := zerolog.ConsoleWriter{Out: ioutil.Discard}

	if analyseArgs.verbose {
		consoleLogger = zerolog.ConsoleWriter{Out: os.Stdout}
	}

	if analyseArgs.logFile {
		file, err := os.OpenFile("info.log", os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0666)
		if err != nil {
			return err
		}
		fileLogger = customConsoleWriter(&zerolog.ConsoleWriter{Out: file, NoColor: true})
	}

	mw := io.MultiWriter(consoleLogger, fileLogger)
	log.Logger = log.Output(mw)

	querySource := &query.FilesystemSource{
		Source: analyseArgs.queryPath,
	}

	t := &tracker.CITracker{}
	inspector, err := engine.NewInspector(ctx, querySource, engine.DefaultVulnerabilityBuilder, t)
	if err != nil {
		return err
	}

	var excludeFiles []string
	if analyseArgs.payloadPath != "" {
		excludeFiles = append(excludeFiles, analyseArgs.payloadPath)
	}

	filesSource, err := source.NewFileSystemSourceProvider(analyseArgs.path, excludeFiles)
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

	summary := model.CreateSummary(counters, result, scanID)

	if err := printJSON(analyseArgs.payloadPath, files.Combine()); err != nil {
		return err
	}

	if err := printJSON(analyseArgs.outputPath, summary); err != nil {
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

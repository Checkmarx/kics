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

type InitOptions struct {
	Ctx         context.Context
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
	ctx         context.Context
	path        string
	queryPath   string
	outputPath  string
	payloadPath string
	verbose     bool
	logFile     bool
	generateID  bool
}

const (
	scanID   = "console"
	timeMult = 2
)

// Init executes kics with the given flags
func Init(initArgs InitOptions) error {
	defer sentry.Flush(timeMult * time.Second)

	if initArgs.Version {
		fmt.Printf("%s\n", getVersion())
		return nil
	}

	analyseArgs := analyseOptions{
		ctx:         initArgs.Ctx,
		path:        initArgs.Path,
		queryPath:   initArgs.QueryPath,
		outputPath:  initArgs.OutputPath,
		payloadPath: initArgs.PayloadPath,
		verbose:     initArgs.Verbose,
		logFile:     initArgs.LogFile,
		generateID:  initArgs.GenerateID,
	}

	return analyse(analyseArgs)
}

func getVersion() string {
	return "Keeping Infrastructure as Code Secure v1.1.0"
}

func analyse(analyseArgs analyseOptions) error {
	fmt.Printf("Starting analysis using %s", getVersion())

	consoleLogger := zerolog.ConsoleWriter{Out: ioutil.Discard}
	fileLogger := zerolog.ConsoleWriter{Out: ioutil.Discard}

	if analyseArgs.verbose {
		consoleLogger = zerolog.ConsoleWriter{Out: os.Stdout}
	}

	if analyseArgs.generateID {
		_, err := fmt.Println(uuid.New().String())
		if err != nil {
			log.Err(err).Msg("failed to get uuid")
			os.Exit(-1)
		}
		os.Exit(0)
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
	inspector, err := engine.NewInspector(analyseArgs.ctx, querySource, engine.DefaultVulnerabilityBuilder, t)
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

	if scanErr := service.StartScan(analyseArgs.ctx, scanID); scanErr != nil {
		return scanErr
	}

	result, err := store.GetVulnerabilities(analyseArgs.ctx, scanID)
	if err != nil {
		return err
	}

	files, err := store.GetFiles(analyseArgs.ctx, scanID)
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

	if analyseArgs.payloadPath != "" {
		if err := printToJSONFile(analyseArgs.payloadPath, files.Combine()); err != nil {
			return err
		}
	}

	if analyseArgs.outputPath != "" {
		if err := printToJSONFile(analyseArgs.outputPath, summary); err != nil {
			return err
		}
	}

	if err := printResult(&summary); err != nil {
		return err
	}

	if summary.FailedToExecuteQueries > 0 {
		os.Exit(1)
	}

	return nil
}

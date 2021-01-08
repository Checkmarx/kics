package main

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
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
)

func startKics(ctx context.Context, path, queryPath, outputPath, payloadPath string, verbose, logFile, version bool) error {
	defer sentry.Flush(timeMult * time.Second)

	if version {
		fmt.Printf("%s\n", getKicsVersion())
		return nil
	}

	return executeAnalysis(ctx, path, queryPath, outputPath, payloadPath, verbose, logFile)
}

func getKicsVersion() string {
	return "Keeping Infrastructure as Code Secure v1.1.0"
}

func executeAnalysis(ctx context.Context, path, queryPath, outputPath, payloadPath string, verbose, logFile bool) error {
	fmt.Printf("Starting analysis using %s", getKicsVersion())

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
}

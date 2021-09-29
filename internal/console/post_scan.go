package console

import (
	_ "embed" // Embed kics CLI img and scan-flags
	"fmt"
	"os"
	"os/signal"
	"path/filepath"
	"strings"
	"syscall"
	"time"

	"github.com/Checkmarx/kics/internal/console/flags"
	consoleHelpers "github.com/Checkmarx/kics/internal/console/helpers"
	"github.com/Checkmarx/kics/internal/constants"
	"github.com/Checkmarx/kics/internal/tracker"
	"github.com/Checkmarx/kics/pkg/descriptions"
	"github.com/Checkmarx/kics/pkg/engine/provider"
	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/pkg/progress"
	"github.com/Checkmarx/kics/pkg/report"
	"github.com/rs/zerolog/log"
)

func getSummary(t *tracker.CITracker, results []model.Vulnerability, start, end time.Time,
	pathParameters model.PathParameters) model.Summary {
	counters := model.Counters{
		ScannedFiles:           t.FoundFiles,
		ParsedFiles:            t.ParsedFiles,
		TotalQueries:           t.LoadedQueries,
		FailedToExecuteQueries: t.ExecutingQueries - t.ExecutedQueries,
		FailedSimilarityID:     t.FailedSimilarityID,
	}

	summary := model.CreateSummary(counters, results, scanID, pathParameters.PathExtractionMap)
	summary.Times = model.Times{
		Start: start,
		End:   end,
	}

	if flags.GetBoolFlag(flags.DisableCISDescFlag) || flags.GetBoolFlag(flags.DisableFullDescFlag) {
		log.Warn().Msg("Skipping CIS descriptions because provided disable flag is set")
	} else {
		err := descriptions.RequestAndOverrideDescriptions(&summary)
		if err != nil {
			log.Warn().Msgf("Unable to get descriptions: %s", err)
			log.Warn().Msgf("Using default descriptions")
		}
	}

	return summary
}

func resolveOutputs(
	summary *model.Summary,
	documents model.Documents,
	failedQueries map[string]error,
	printer *consoleHelpers.Printer,
	proBarBuilder progress.PbBuilder,
) error {
	log.Debug().Msg("console.resolveOutputs()")

	if err := consoleHelpers.PrintResult(summary, failedQueries, printer); err != nil {
		return err
	}
	if flags.GetStrFlag(flags.PayloadPathFlag) != "" {
		if err := report.ExportJSONReport(
			filepath.Dir(flags.GetStrFlag(flags.PayloadPathFlag)),
			filepath.Base(flags.GetStrFlag(flags.PayloadPathFlag)),
			documents,
		); err != nil {
			return err
		}
	}

	return printOutput(
		flags.GetStrFlag(flags.OutputPathFlag),
		flags.GetStrFlag(flags.OutputNameFlag),
		summary, flags.GetMultiStrFlag(flags.ReportFormatsFlag),
		proBarBuilder,
	)
}

func printOutput(outputPath, filename string, body interface{}, formats []string, proBarBuilder progress.PbBuilder) error {
	log.Debug().Msg("console.printOutput()")
	if outputPath == "" {
		return nil
	}
	if len(formats) == 0 {
		formats = []string{"json"}
	}

	log.Debug().Msgf("Output formats provided [%v]", strings.Join(formats, ","))
	err := consoleHelpers.GenerateReport(outputPath, filename, body, formats, proBarBuilder)

	return err
}

func printScanDuration(elapsed time.Duration) {
	if flags.GetBoolFlag(flags.CIFlag) {
		elapsedStrFormat := "Scan duration: %vms\n"
		fmt.Printf(elapsedStrFormat, elapsed.Milliseconds())
		log.Info().Msgf(elapsedStrFormat, elapsed.Milliseconds())
	} else {
		elapsedStrFormat := "Scan duration: %v\n"
		fmt.Printf(elapsedStrFormat, elapsed)
		log.Info().Msgf(elapsedStrFormat, elapsed)
	}
}

// posScan is responsible for the output results
func posScan(t *tracker.CITracker, results []model.Vulnerability, scanStartTime time.Time, extractedPaths provider.ExtractedPath,
	files model.FileMetadatas, failedQueries map[string]error, printer *consoleHelpers.Printer, proBarBuilder *progress.PbBuilder) error {
	summary := getSummary(t, results, scanStartTime, time.Now(), model.PathParameters{
		ScannedPaths:      flags.GetMultiStrFlag(flags.PathFlag),
		PathExtractionMap: extractedPaths.ExtractionMap,
	})

	if err := resolveOutputs(
		&summary,
		files.Combine(flags.GetBoolFlag(flags.LineInfoPayloadFlag)),
		failedQueries,
		printer,
		*proBarBuilder); err != nil {
		log.Err(err)
		return err
	}

	printScanDuration(time.Since(scanStartTime))

	exitCode := consoleHelpers.ResultsExitCode(&summary)
	if consoleHelpers.ShowError("results") && exitCode != 0 {
		os.Exit(exitCode)
	}

	return nil
}

// gracefulShutdown catches signal interrupt and returns the appropriate exit code
func gracefulShutdown() {
	c := make(chan os.Signal)
	// This line should not be lint, since golangci-lint has an issue about it (https://github.com/golang/go/issues/45043)
	signal.Notify(c, os.Interrupt, syscall.SIGTERM) // nolint
	showErrors := consoleHelpers.ShowError("errors")
	interruptCode := constants.SignalInterruptCode
	go func(showErrors bool, interruptCode int) {
		<-c
		if showErrors {
			os.Exit(interruptCode)
		}
	}(showErrors, interruptCode)
}

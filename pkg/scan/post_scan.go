package scan

import (
	_ "embed" // Embed kics CLI img and scan-flags
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"time"

	consoleHelpers "github.com/Checkmarx/kics/internal/console/helpers"
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

	summary := model.CreateSummary(counters, results, ScanParams.ScanID, pathParameters.PathExtractionMap)
	summary.Times = model.Times{
		Start: start,
		End:   end,
	}

	if ScanParams.DisableCISDescFlag || ScanParams.DisableFullDescFlag {
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
	if ScanParams.PayloadPathFlag != "" {
		if err := report.ExportJSONReport(
			filepath.Dir(ScanParams.PayloadPathFlag),
			filepath.Base(ScanParams.PayloadPathFlag),
			documents,
		); err != nil {
			return err
		}
	}

	return printOutput(
		ScanParams.OutputPathFlag,
		ScanParams.OutputNameFlag,
		summary, ScanParams.ReportFormatsFlag,
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
	if ScanParams.CIFlag {
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
		ScannedPaths:      ScanParams.PathFlag,
		PathExtractionMap: extractedPaths.ExtractionMap,
	})

	if err := resolveOutputs(
		&summary,
		files.Combine(ScanParams.LineInfoPayloadFlag),
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

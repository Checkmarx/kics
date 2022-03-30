package scan

import (
	_ "embed" // Embed kics CLI img and scan-flags
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"time"

	consoleHelpers "github.com/Checkmarx/kics/internal/console/helpers"
	"github.com/Checkmarx/kics/pkg/descriptions"
	"github.com/Checkmarx/kics/pkg/model"
	consolePrinter "github.com/Checkmarx/kics/pkg/printer"
	"github.com/Checkmarx/kics/pkg/progress"
	"github.com/Checkmarx/kics/pkg/report"
	"github.com/rs/zerolog/log"
)

func (c *Client) getSummary(results []model.Vulnerability, end time.Time, pathParameters model.PathParameters) model.Summary {
	counters := model.Counters{
		ScannedFiles:           c.Tracker.FoundFiles,
		ScannedFilesLines:      c.Tracker.FoundCountLines,
		ParsedFilesLines:       c.Tracker.ParsedCountLines,
		ParsedFiles:            c.Tracker.ParsedFiles,
		TotalQueries:           c.Tracker.LoadedQueries,
		FailedToExecuteQueries: c.Tracker.ExecutingQueries - c.Tracker.ExecutedQueries,
		FailedSimilarityID:     c.Tracker.FailedSimilarityID,
	}

	summary := model.CreateSummary(counters, results, c.ScanParams.ScanID, pathParameters.PathExtractionMap, c.Tracker.Version)
	summary.Times = model.Times{
		Start: c.ScanStartTime,
		End:   end,
	}

	if c.ScanParams.DisableCISDesc || c.ScanParams.DisableFullDesc {
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

func (c *Client) resolveOutputs(
	summary *model.Summary,
	documents model.Documents,
	failedQueries map[string]error,
	printer *consolePrinter.Printer,
	proBarBuilder progress.PbBuilder,
) error {
	log.Debug().Msg("console.resolveOutputs()")

	if err := consolePrinter.PrintResult(summary, failedQueries, printer); err != nil {
		return err
	}
	if c.ScanParams.PayloadPath != "" {
		if err := report.ExportJSONReport(
			filepath.Dir(c.ScanParams.PayloadPath),
			filepath.Base(c.ScanParams.PayloadPath),
			documents,
		); err != nil {
			return err
		}
	}

	return printOutput(
		c.ScanParams.OutputPath,
		c.ScanParams.OutputName,
		summary, c.ScanParams.ReportFormats,
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

// postScan is responsible for the output results
func (c *Client) postScan(scanResults *Results) error {
	if scanResults == nil {
		log.Info().Msg("No files were scanned")
		fmt.Println("No files were scanned")
		return nil
	}

	summary := c.getSummary(scanResults.Results, time.Now(), model.PathParameters{
		ScannedPaths:      c.ScanParams.Path,
		PathExtractionMap: scanResults.ExtractedPaths.ExtractionMap,
	})

	if err := c.resolveOutputs(
		&summary,
		scanResults.Files.Combine(c.ScanParams.LineInfoPayload),
		scanResults.FailedQueries,
		c.Printer,
		*c.ProBarBuilder); err != nil {
		log.Err(err)
		return err
	}

	deleteExtractionFolder(scanResults.ExtractedPaths.ExtractionMap)

	consolePrinter.PrintScanDuration(time.Since(c.ScanStartTime))

	printVersionCheck(c.Printer, &summary)

	contributionAppeal(c.Printer, c.ScanParams.QueriesPath)

	exitCode := consoleHelpers.ResultsExitCode(&summary)
	if consoleHelpers.ShowError("results") && exitCode != 0 {
		os.Exit(exitCode)
	}

	return nil
}

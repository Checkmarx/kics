package scan

import (
	_ "embed" // Embed kics CLI img and scan-flags
	"os"
	"path/filepath"
	"sort"
	"strings"
	"time"

	consoleHelpers "github.com/Checkmarx/kics/v2/internal/console/helpers"
	"github.com/Checkmarx/kics/v2/pkg/descriptions"
	"github.com/Checkmarx/kics/v2/pkg/engine/provider"
	"github.com/Checkmarx/kics/v2/pkg/model"
	consolePrinter "github.com/Checkmarx/kics/v2/pkg/printer"
	"github.com/Checkmarx/kics/v2/pkg/progress"
	"github.com/Checkmarx/kics/v2/pkg/report"
	"github.com/rs/zerolog/log"
)

func (c *Client) getSummary(results []model.Vulnerability, end time.Time, pathParameters model.PathParameters) model.Summary {
	counters := model.Counters{
		ScannedFiles:           c.Tracker.FoundFiles,
		ScannedFilesLines:      c.Tracker.FoundCountLines,
		ParsedFilesLines:       c.Tracker.ParsedCountLines,
		ParsedFiles:            c.Tracker.ParsedFiles,
		IgnoredFilesLines:      c.Tracker.IgnoreCountLines,
		TotalQueries:           c.Tracker.LoadedQueries,
		FailedToExecuteQueries: c.Tracker.ExecutingQueries - c.Tracker.ExecutedQueries,
		FailedSimilarityID:     c.Tracker.FailedSimilarityID,
	}

	summary := model.CreateSummary(&counters, results, c.ScanParams.ScanID, pathParameters.PathExtractionMap, c.Tracker.Version)
	summary.Times = model.Times{
		Start: c.ScanStartTime,
		End:   end,
	}

	if c.ScanParams.DisableFullDesc {
		log.Warn().Msg("Skipping descriptions because provided disable flag is set")
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
	printer *consolePrinter.Printer,
	proBarBuilder progress.PbBuilder,
) error {
	log.Debug().Msg("console.resolveOutputs()")

	usingCustomQueries := usingCustomQueries(c.ScanParams.QueriesPath)
	if err := consolePrinter.PrintResult(summary, printer, usingCustomQueries); err != nil {
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
		scanResults = &Results{
			Results:        []model.Vulnerability{},
			ExtractedPaths: provider.ExtractedPath{},
			Files:          model.FileMetadatas{},
			FailedQueries:  map[string]error{},
		}
	}

	// mask results preview if Secrets Scan is disabled
	if c.ScanParams.DisableSecrets {
		err := maskPreviewLines(c.ScanParams.SecretsRegexesPath, scanResults)
		if err != nil {
			log.Err(err)
			return err
		}
	}
	sort.Strings(c.ScanParams.Path)
	summary := c.getSummary(scanResults.Results, time.Now(), model.PathParameters{
		ScannedPaths:      c.ScanParams.Path,
		PathExtractionMap: scanResults.ExtractedPaths.ExtractionMap,
	})

	if err := c.resolveOutputs(
		&summary,
		scanResults.Files.Combine(c.ScanParams.LineInfoPayload),
		c.Printer,
		*c.ProBarBuilder); err != nil {
		log.Err(err)
		return err
	}

	deleteExtractionFolder(scanResults.ExtractedPaths.ExtractionMap)

	logger := consolePrinter.NewLogger(nil)
	consolePrinter.PrintScanDuration(&logger, time.Since(c.ScanStartTime))

	printVersionCheck(c.Printer, &summary)

	contributionAppeal(c.Printer, c.ScanParams.QueriesPath)

	exitCode := consoleHelpers.ResultsExitCode(&summary)
	if consoleHelpers.ShowError("results") && exitCode != 0 {
		os.Exit(exitCode)
	}

	return nil
}

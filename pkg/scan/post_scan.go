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
	"github.com/Checkmarx/kics/pkg/progress"
	"github.com/Checkmarx/kics/pkg/report"
	"github.com/rs/zerolog/log"
)

func (c *Client) getSummary(end time.Time, pathParameters model.PathParameters) model.Summary {
	counters := model.Counters{
		ScannedFiles:           c.Tracker.FoundFiles,
		ParsedFiles:            c.Tracker.ParsedFiles,
		TotalQueries:           c.Tracker.LoadedQueries,
		FailedToExecuteQueries: c.Tracker.ExecutingQueries - c.Tracker.ExecutedQueries,
		FailedSimilarityID:     c.Tracker.FailedSimilarityID,
	}

	summary := model.CreateSummary(counters, c.Results, c.ScanParams.ScanID, pathParameters.PathExtractionMap)
	summary.Times = model.Times{
		Start: c.ScanStartTime,
		End:   end,
	}

	if c.ScanParams.DisableCISDescFlag || c.ScanParams.DisableFullDescFlag {
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
	printer *consoleHelpers.Printer,
	proBarBuilder progress.PbBuilder,
) error {
	log.Debug().Msg("console.resolveOutputs()")

	if err := consoleHelpers.PrintResult(summary, failedQueries, printer); err != nil {
		return err
	}
	if c.ScanParams.PayloadPathFlag != "" {
		if err := report.ExportJSONReport(
			filepath.Dir(c.ScanParams.PayloadPathFlag),
			filepath.Base(c.ScanParams.PayloadPathFlag),
			documents,
		); err != nil {
			return err
		}
	}

	return printOutput(
		c.ScanParams.OutputPathFlag,
		c.ScanParams.OutputNameFlag,
		summary, c.ScanParams.ReportFormatsFlag,
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

func (c *Client) printScanDuration(elapsed time.Duration) {
	if c.ScanParams.CIFlag {
		elapsedStrFormat := "Scan duration: %vms\n"
		fmt.Printf(elapsedStrFormat, elapsed.Milliseconds())
		log.Info().Msgf(elapsedStrFormat, elapsed.Milliseconds())
	} else {
		elapsedStrFormat := "Scan duration: %v\n"
		fmt.Printf(elapsedStrFormat, elapsed)
		log.Info().Msgf(elapsedStrFormat, elapsed)
	}
}

// postScan is responsible for the output results
func (c *Client) postScan() error {
	summary := c.getSummary(time.Now(), model.PathParameters{
		ScannedPaths:      c.ScanParams.PathFlag,
		PathExtractionMap: c.ExtractedPaths.ExtractionMap,
	})

	if err := c.resolveOutputs(
		&summary,
		c.Files.Combine(c.ScanParams.LineInfoPayloadFlag),
		c.FailedQueries,
		c.Printer,
		*c.ProBarBuilder); err != nil {
		log.Err(err)
		return err
	}

	c.printScanDuration(time.Since(c.ScanStartTime))

	exitCode := consoleHelpers.ResultsExitCode(&summary)
	if consoleHelpers.ShowError("results") && exitCode != 0 {
		os.Exit(exitCode)
	}

	return nil
}

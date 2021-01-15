package console

import (
	"encoding/json"
	"fmt"
	"os"
	"strings"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
)

func printResult(summary *model.Summary) error {
	fmt.Printf("Files scanned: %d\n", summary.ScannedFiles)
	fmt.Printf("Parsed files: %d\n", summary.ParsedFiles)
	fmt.Printf("Queries loaded: %d\n", summary.TotalQueries)
	fmt.Printf("Queries failed to execute: %d\n\n", summary.FailedToExecuteQueries)
	for _, q := range summary.Queries {
		fmt.Printf("%s, Severity: %s, Results: %d\n", q.QueryName, q.Severity, len(q.Files))
		for _, f := range q.Files {
			fmt.Printf("\t%s:%d\n", f.FileName, f.Line)
		}
	}
	fmt.Printf("\nResults Summary:\n")
	fmt.Printf("HIGH: %d\n", summary.SeveritySummary.SeverityCounters["HIGH"])
	fmt.Printf("MEDIUM: %d\n", summary.SeveritySummary.SeverityCounters["MEDIUM"])
	fmt.Printf("LOW: %d\n", summary.SeveritySummary.SeverityCounters["LOW"])
	fmt.Printf("INFO: %d\n", summary.SeveritySummary.SeverityCounters["INFO"])
	fmt.Printf("TOTAL: %d\n\n", summary.SeveritySummary.TotalCounter)
	log.
		Info().
		Msgf("\n\nFiles scanned: %d\n"+
			"Parsed files: %d\nQueries loaded: %d\n"+
			"Queries failed to execute: %d\n",
			summary.ScannedFiles, summary.ParsedFiles, summary.TotalQueries, summary.FailedToExecuteQueries)
	log.
		Info().
		Msg("Inspector stopped\n")

	return nil
}

func printToJSONFile(path string, body interface{}) error {
	f, err := os.OpenFile(path, os.O_WRONLY|os.O_CREATE|os.O_TRUNC, os.ModePerm)
	if err != nil {
		return err
	}
	defer func() {
		if err := f.Close(); err != nil {
			log.Err(err).Msgf("failed to close file %s", path)
		}

		log.Info().Str("fileName", path).Msgf("Results saved to file %s", path)
	}()

	encoder := json.NewEncoder(f)
	encoder.SetIndent("", "\t")

	return encoder.Encode(body)
}

func customConsoleWriter(fileLogger *zerolog.ConsoleWriter) zerolog.ConsoleWriter {
	fileLogger.FormatLevel = func(i interface{}) string {
		return strings.ToUpper(fmt.Sprintf("| %-6s|", i))
	}

	fileLogger.FormatFieldName = func(i interface{}) string {
		return fmt.Sprintf("%s:", i)
	}

	fileLogger.FormatErrFieldName = func(i interface{}) string {
		return "ERROR:"
	}

	fileLogger.FormatFieldValue = func(i interface{}) string {
		return strings.ToUpper(fmt.Sprintf("%s", i))
	}

	return *fileLogger
}

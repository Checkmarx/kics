package console

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"strings"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
)

// Constants with KICS info
const (
	CurrentKICSVersion  = "1.1.2"
	CurrentKICSFullname = "Keeping Infrastructure as Code Secure"
)

// wordWrap Wraps text at the specified number of words
func wordWrap(s, identation string, limit int) string {
	if strings.TrimSpace(s) == "" {
		return s
	}

	wordSlice := strings.Fields(s)
	var result string

	for len(wordSlice) >= 1 {
		result = result + identation + strings.Join(wordSlice[:limit], " ") + "\r\n"

		wordSlice = wordSlice[limit:]
		if len(wordSlice) < limit {
			limit = len(wordSlice)
		}
	}
	return result
}

func printResult(summary *model.Summary, failedQueries map[string]error) error {
	fmt.Printf("Files scanned: %d\n", summary.ScannedFiles)
	fmt.Printf("Parsed files: %d\n", summary.ParsedFiles)
	fmt.Printf("Queries loaded: %d\n", summary.TotalQueries)

	fmt.Printf("Queries failed to execute: %d\n", summary.FailedToExecuteQueries)
	for queryName, err := range failedQueries {
		fmt.Printf("\t- %s:\n", queryName)
		fmt.Printf("%s", wordWrap(err.Error(), "\t\t", 5))
	}
	fmt.Printf("------------------------------------\n")
	for _, q := range summary.Queries {
		fmt.Printf("%s, Severity: %s, Results: %d\n", q.QueryName, q.Severity, len(q.Files))

		for i := 0; i < len(q.Files); i++ {
			fmt.Printf("\t%s:%d\n", q.Files[i].FileName, q.Files[i].Line)
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

func closeFile(f *os.File) {
	if err := f.Close(); err != nil {
		log.Err(err).Msgf("failed to close file %s", path)
	}

	curDir, err := os.Getwd()
	if err != nil {
		log.Err(err).Msgf("failed to get current directory")
	}

	log.Info().Str("fileName", path).Msgf("Results saved to file %s", filepath.Join(curDir, path))
}

func printToJSONFile(path string, body interface{}) error {
	f, err := os.OpenFile(filepath.Clean(path), os.O_WRONLY|os.O_CREATE|os.O_TRUNC, os.ModePerm)
	if err != nil {
		return err
	}
	defer closeFile(f)

	encoder := json.NewEncoder(f)
	encoder.SetIndent("", "\t")

	return encoder.Encode(body)
}

func printToSarifFile(path string, summary *model.Summary) error {
	sarifReport := model.NewSarifReport()
	for idx := range summary.Queries {
		sarifReport.BuildIssue(&summary.Queries[idx])
	}

	return printJSON(path, sarifReport)
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
		return fmt.Sprintf("%s", i)
	}

	return *fileLogger
}

package console

import (
	"encoding/json"
	"fmt"
	"math"
	"os"
	"strings"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
)

// ProgressBar prints a progress bar on console
func ProgressBar(progress <-chan int, total float64, space int) {
	var firstHalfPercentage, secondHalfPercentage string
	const hundredPercent = 100
	formmatingString := "\r[%s %" + fmt.Sprintf("%d", len(fmt.Sprintf("%d", int(total)))) + "d / %d %s]"
	for {
		currentProgress := <-progress
		percentage := math.Round(float64(currentProgress) / total * hundredPercent)
		convertedPercentage := int(math.Round(float64(space+space) / hundredPercent * percentage))
		if percentage > hundredPercent/2 {
			firstHalfPercentage = strings.Repeat("=", space)
			secondHalfPercentage = strings.Repeat("=", convertedPercentage-space) +
				strings.Repeat(" ", 2*space-convertedPercentage)
		} else {
			secondHalfPercentage = strings.Repeat(" ", space)
			firstHalfPercentage = strings.Repeat("=", convertedPercentage) +
				strings.Repeat(" ", space-convertedPercentage)
		}
		fmt.Printf(formmatingString, firstHalfPercentage, currentProgress, int(total), secondHalfPercentage)
	}
}

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
		return fmt.Sprintf("%s", i)
	}

	return *fileLogger
}

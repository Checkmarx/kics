package report

import (
	"strings"

	reportModel "github.com/Checkmarx/kics/v2/pkg/report/model"
)

// PrintCSVReport prints the CSV report in the given path and filename with the given body
func PrintCSVReport(path, filename string, body interface{}) error {
	if !strings.HasSuffix(filename, ".csv") {
		filename += ".csv"
	}

	var report []reportModel.CSVReport
	if body != "" {
		summary, err := getSummary(body)
		if err != nil {
			return err
		}

		report = reportModel.BuildCSVReport(&summary)
	}

	return exportCSVReport(path, filename, report)
}

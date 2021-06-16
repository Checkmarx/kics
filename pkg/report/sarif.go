package report

import (
	"strings"

	reportModel "github.com/Checkmarx/kics/pkg/report/model"
)

// PrintSarifReport creates a report file on sarif format
func PrintSarifReport(path, filename string, body interface{}) error {
	if !strings.HasSuffix(filename, ".sarif") {
		filename += ".sarif"
	}
	if body != "" {
		summary, err := getSummary(body)
		if err != nil {
			return err
		}

		sarifReport := reportModel.NewSarifReport()
		for idx := range summary.Queries {
			sarifReport.BuildSarifIssue(&summary.Queries[idx])
		}
		body = sarifReport
	}

	return ExportJSONReport(path, filename, body)
}

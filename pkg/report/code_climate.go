package report

import (
	"strings"

	reportModel "github.com/Checkmarx/kics/v2/pkg/report/model"
)

// PrintCodeClimateReport prints the code climate report in the given path and filename with the given body
func PrintCodeClimateReport(path, filename string, body interface{}) error {
	if !strings.HasPrefix(filename, "codeclimate") {
		filename = "codeclimate-" + filename
	}

	if body != "" {
		summary, err := getSummary(body)
		if err != nil {
			return err
		}

		body = reportModel.BuildCodeClimateReport(&summary)
	}

	return ExportJSONReport(path, filename, body)
}

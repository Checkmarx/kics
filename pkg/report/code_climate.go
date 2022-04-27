package report

import (
	"strings"

	reportModel "github.com/Checkmarx/kics/pkg/report/model"
)

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

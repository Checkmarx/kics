package report

import (
	"strings"

	reportModel "github.com/Checkmarx/kics/v2/pkg/report/model"
)

// PrintASFFReport prints the ASFF report in the given path and filename with the given body
func PrintASFFReport(path, filename string, body interface{}) error {
	if !strings.HasPrefix(filename, "asff-") {
		filename = "asff-" + filename
	}
	if body != "" {
		summary, err := getSummary(body)
		if err != nil {
			return err
		}

		body = reportModel.BuildASFF(&summary)
	}

	return ExportJSONReport(path, filename, body)
}

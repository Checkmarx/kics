package report

import (
	"strings"

	reportModel "github.com/Checkmarx/kics/pkg/report/model"
)

func PrintCodeQualityReport(path, filename string, body interface{}) error {
	if !strings.HasPrefix(filename, "codequality") {
		filename = "codequality-" + filename
	}

	if body != "" {
		summary, err := getSummary(body)
		if err != nil {
			return err
		}

		body = reportModel.BuildCodeQualityReport(&summary)
	}

	return ExportJSONReport(path, filename, body)
}

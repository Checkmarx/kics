package report

import (
	"strings"

	reportModel "github.com/Checkmarx/kics/pkg/report/model"
)

// PrintCycloneDxReport prints the CycloneDX report in the given path and filename with the given body
func PrintCycloneDxReport(path, filename string, body interface{}) error {
	if !strings.HasPrefix(filename, "cyclonedx-") {
		filename = "cyclonedx-" + filename
	}

	if body != "" {
		summary, err := getSummary(body)
		if err != nil {
			return err
		}

		body = reportModel.BuildCycloneDxReport(&summary)
	}

	return ExportXMLReport(path, filename, body)
}

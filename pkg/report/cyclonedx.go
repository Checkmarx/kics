package report

import (
	"strings"

	"github.com/Checkmarx/kics/v2/pkg/model"
	reportModel "github.com/Checkmarx/kics/v2/pkg/report/model"
)

// PrintCycloneDxReport prints the CycloneDX report in the given path and filename with the given body
func PrintCycloneDxReport(path, filename string, body interface{}) error {
	filePaths := make(map[string]string)

	if !strings.HasPrefix(filename, "cyclonedx-") {
		filename = "cyclonedx-" + filename
	}

	if body != "" {
		if s, ok := body.(*model.Summary); ok {
			filePaths = s.FilePaths
		}
		summary, err := getSummary(body)
		if err != nil {
			return err
		}

		body = reportModel.BuildCycloneDxReport(&summary, filePaths)
	}

	return exportXMLReport(path, filename, body)
}

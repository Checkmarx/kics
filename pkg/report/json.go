package report

import (
	"github.com/Checkmarx/kics/internal/constants"
	"github.com/Checkmarx/kics/pkg/utils"
)

const jsonExtension = ".json"

// PrintJSONReport prints on JSON file the summary results
func PrintJSONReport(path, filename string, body interface{}) error {
	defer utils.PanicHandler()
	if body != "" {
		summary, err := getSummary(body)
		if err != nil {
			return err
		}
		for idx := range summary.Queries {
			summary.Queries[idx].CISBenchmarkName = ""
			summary.Queries[idx].CISBenchmarkVersion = ""
			summary.Queries[idx].CISDescriptionID = ""
			summary.Queries[idx].CISDescriptionText = ""
			summary.Queries[idx].CISRationaleText = ""
		}
		summary.Version = constants.Version
		body = summary
	}

	return ExportJSONReport(path, filename, body)
}

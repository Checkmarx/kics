package report

import "github.com/Checkmarx/kics/internal/constants"

const jsonExtension = ".json"

// PrintJSONReport prints on JSON file the summary results
func PrintJSONReport(path, filename string, body interface{}) error {
	if body != "" {
		summary, err := getSummary(body)
		if err != nil {
			return err
		}
		summary.Version = constants.Version
		body = summary
	}

	return ExportJSONReport(path, filename, body)
}

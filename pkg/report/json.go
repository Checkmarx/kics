package report

import (
	"os"
)

const jsonExtension = ".json"

// PrintJSONReport prints on JSON file the summary results
func PrintJSONReport(path, filename string, body interface{}) error {
	if body != "" {
		summary, err := getSummary(body)
		if err != nil {
			return err
		}

		basePath, err := os.Getwd()
		if err != nil {
			return err
		}

		for i := range summary.Queries {
			query := summary.Queries[i]
			for j := range query.Files {
				query.Files[j].FileName = getRelativePath(basePath, query.Files[j].FileName)
			}
		}
		body = summary
	}

	return ExportJSONReport(path, filename, body)
}

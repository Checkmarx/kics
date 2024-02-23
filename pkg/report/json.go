package report

import (
	"sort"

	"github.com/Checkmarx/kics/internal/constants"
)

const jsonExtension = ".json"

// PrintJSONReport prints on JSON file the summary results
func PrintJSONReport(path, filename string, body interface{}) error {
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

			files := summary.Queries[idx].Files
			sort.Slice(files, func(i, j int) bool {
				if files[i].FileName != files[j].FileName {
					return files[i].FileName < files[j].FileName
				}

				if files[i].SimilarityID != files[j].SimilarityID {
					return files[i].SimilarityID < files[j].SimilarityID
				}

				if files[i].IssueType != files[j].IssueType {
					return files[i].IssueType < files[j].IssueType
				}

				return files[i].KeyExpectedValue < files[j].KeyExpectedValue
			})

			summary.Queries[idx].Files = files
		}
		summary.Version = constants.Version
		body = summary
	}

	return ExportJSONReport(path, filename, body)
}

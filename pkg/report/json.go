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

		queries := summary.Queries
		sort.SliceStable(queries, func(i, j int) bool {
			if queries[i].Severity == queries[j].Severity {
				return queries[i].QueryName < queries[j].QueryName
			}

			return false
		})

		for idx := range queries {
			queries[idx].CISBenchmarkName = ""
			queries[idx].CISBenchmarkVersion = ""
			queries[idx].CISDescriptionID = ""
			queries[idx].CISDescriptionText = ""
			queries[idx].CISRationaleText = ""

			files := queries[idx].Files
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

			queries[idx].Files = files
			summary.Queries = queries
		}
		summary.Version = constants.Version
		body = summary
	}

	return ExportJSONReport(path, filename, body)
}

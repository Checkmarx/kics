package report

import (
	"strings"

	reportModel "github.com/Checkmarx/kics/v2/pkg/report/model"
)

// PrintSonarQubeReport prints the SonarQube report in the given path and filename with the given body
func PrintSonarQubeReport(path, filename string, body interface{}) error {
	if !strings.HasSuffix(filename, ".json") {
		filename += ".json"
	}

	if !strings.HasPrefix(filename, "sonarqube-") {
		filename = "sonarqube-" + filename
	}

	if body != "" {
		summary, err := getSummary(body)
		if err != nil {
			return err
		}

		SonarQubeReport := reportModel.NewSonarQubeRepory()
		body = SonarQubeReport.BuildReport(&summary)
	}

	return ExportJSONReport(path, filename, body)
}

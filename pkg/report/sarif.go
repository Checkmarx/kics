package report

import (
	"encoding/json"
	"strings"

	"github.com/Checkmarx/kics/pkg/model"
	reportModel "github.com/Checkmarx/kics/pkg/report/model"
)

// PrintSarifReport creates a report file on sarif format
func PrintSarifReport(path, filename string, body interface{}) error {
	if !strings.HasSuffix(filename, ".sarif") {
		filename += ".sarif"
	}
	var summary model.Summary
	result, err := json.Marshal(body)
	if err != nil {
		return err
	}
	if err := json.Unmarshal(result, &summary); err != nil {
		return err
	}

	sarifReport := reportModel.NewSarifReport()
	for idx := range summary.Queries {
		sarifReport.BuildSarifIssue(&summary.Queries[idx])
	}

	return PrintJSONReport(path, filename, sarifReport)
}

package report

import (
	"strings"

	"github.com/Checkmarx/kics/v2/pkg/model"
	reportModel "github.com/Checkmarx/kics/v2/pkg/report/model"
)

// PrintJUnitReport prints the JUnit report in the given path and filename with the given body
func PrintJUnitReport(path, filename string, body interface{}) error {
	if !strings.HasPrefix(filename, "junit-") {
		filename = "junit-" + filename
	}

	summary := model.Summary{}

	if body != "" {
		var err error
		summary, err = getSummary(body)
		if err != nil {
			return err
		}
	}

	jUnitReport := reportModel.NewJUnitReport(summary.Times.End.Sub(summary.Times.Start).String())
	for idx := range summary.Queries {
		jUnitReport.GenerateTestEntry(&summary.Queries[idx])
	}

	jUnitReport.FinishReport()

	return exportXMLReport(path, filename, jUnitReport)
}

package report

import (
	"strings"

	reportModel "github.com/Checkmarx/kics/pkg/report/model"
	"github.com/Checkmarx/kics/pkg/utils"
)

// PrintGitlabSASTReport creates a report file on sarif format
func PrintGitlabSASTReport(path, filename string, body interface{}) error {
	defer utils.PanicHandler()
	filename = strings.ReplaceAll(filename, ".glsast", "")
	if !strings.HasSuffix(filename, jsonExtension) {
		filename += jsonExtension
	}
	if !strings.HasPrefix(filename, "gl-sast-") {
		filename = "gl-sast-" + filename
	}
	if body != "" {
		summary, err := getSummary(body)
		if err != nil {
			return err
		}

		gitlabSASTReport := reportModel.NewGitlabSASTReport(summary.Times.Start, summary.Times.End)

		for idxQuery := range summary.Queries {
			for idxFile := range summary.Queries[idxQuery].Files {
				gitlabSASTReport.BuildGitlabSASTVulnerability(&summary.Queries[idxQuery], &summary.Queries[idxQuery].Files[idxFile])
			}
		}
		body = gitlabSASTReport
	}

	return ExportJSONReport(path, filename, body)
}

package report

import (
	"strings"

	reportModel "github.com/Checkmarx/kics/v2/pkg/report/model"
)

// PrintGitlabSASTReport creates a report file on sarif format
func PrintGitlabSASTReport(path, filename string, body interface{}) error {
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

		gitlabSASTReport := reportModel.NewGitlabSASTReport(summary.Start, summary.End)

		for idxQuery := range summary.Queries {
			for idxFile := range summary.Queries[idxQuery].Files {
				gitlabSASTReport.BuildGitlabSASTVulnerability(&summary.Queries[idxQuery], &summary.Queries[idxQuery].Files[idxFile])
			}
		}
		body = gitlabSASTReport
	}

	return ExportJSONReport(path, filename, body)
}

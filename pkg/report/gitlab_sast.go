package report

import (
	"encoding/json"
	"strings"

	"github.com/Checkmarx/kics/pkg/model"
	reportModel "github.com/Checkmarx/kics/pkg/report/model"
)

// PrintGitlabSASTReport creates a report file on sarif format
func PrintGitlabSASTReport(path, filename string, body interface{}) error {
	if !strings.HasSuffix(filename, jsonExtension) {
		filename += jsonExtension
	}
	if !strings.HasPrefix(filename, "gl-sast-") {
		filename = "gl-sast-" + filename
	}
	var summary model.Summary
	result, err := json.Marshal(body)
	if err != nil {
		return err
	}
	if err := json.Unmarshal(result, &summary); err != nil {
		return err
	}

	gitlabSASTReport := reportModel.NewGitlabSASTReport(summary.Times.Start, summary.Times.End)

	for idxQuery := range summary.Queries {
		for idxFile := range summary.Queries[idxQuery].Files {
			gitlabSASTReport.BuildGitlabSASTVulnerability(&summary.Queries[idxQuery], &summary.Queries[idxQuery].Files[idxFile])
		}
	}

	return PrintJSONReport(path, filename, gitlabSASTReport)
}

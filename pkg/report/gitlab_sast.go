/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache-2.0 License.
 *
 * This product includes software developed at Datadog (https://www.datadoghq.com)  Copyright 2024 Datadog, Inc.
 */
package report

import (
	"strings"

	"github.com/Checkmarx/kics/pkg/model"
	reportModel "github.com/Checkmarx/kics/pkg/report/model"
)

// PrintGitlabSASTReport creates a report file on sarif format
func PrintGitlabSASTReport(path, filename string, body interface{}, sciInfo model.SCIInfo) error {
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

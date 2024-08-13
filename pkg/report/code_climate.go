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

// PrintCodeClimateReport prints the code climate report in the given path and filename with the given body
func PrintCodeClimateReport(path, filename string, body interface{}, sciInfo model.SCIInfo) error {
	if !strings.HasPrefix(filename, "codeclimate") {
		filename = "codeclimate-" + filename
	}

	if body != "" {
		summary, err := getSummary(body)
		if err != nil {
			return err
		}

		body = reportModel.BuildCodeClimateReport(&summary)
	}

	return ExportJSONReport(path, filename, body)
}

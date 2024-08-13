/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache-2.0 License.
 *
 * This product includes software developed at Datadog (https://www.datadoghq.com)  Copyright 2024 Datadog, Inc.
 */
package report

import (
	"github.com/Checkmarx/kics/internal/constants"
	"github.com/Checkmarx/kics/pkg/model"
)

const jsonExtension = ".json"

// PrintJSONReport prints on JSON file the summary results
func PrintJSONReport(path, filename string, body interface{}, sciInfo model.SCIInfo) error {
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
		}
		summary.Version = constants.Version
		body = summary
	}

	return ExportJSONReport(path, filename, body)
}

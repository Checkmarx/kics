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

// PrintCycloneDxReport prints the CycloneDX report in the given path and filename with the given body
func PrintCycloneDxReport(path, filename string, body interface{}, sciInfo model.SCIInfo) error {
	filePaths := make(map[string]string)

	if !strings.HasPrefix(filename, "cyclonedx-") {
		filename = "cyclonedx-" + filename
	}

	if body != "" {
		if s, ok := body.(*model.Summary); ok {
			filePaths = s.FilePaths
		}
		summary, err := getSummary(body)
		if err != nil {
			return err
		}

		body = reportModel.BuildCycloneDxReport(&summary, filePaths)
	}

	return exportXMLReport(path, filename, body)
}

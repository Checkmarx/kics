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

// PrintSarifReport creates a report file on sarif format, fetching the ID and GUID from relationships to be inputted to taxonomies field
func PrintSarifReport(path, filename string, body interface{}, sciInfo model.SCIInfo) error {
	if !strings.HasSuffix(filename, ".sarif") {
		filename += ".sarif"
	}
	if body != "" {
		summary, err := getSummary(body)
		if err != nil {
			return err
		}

		sarifReport := reportModel.NewSarifReport()
		auxID := []string{}
		auxGUID := map[string]string{}
		for idx := range summary.Queries {
			x := sarifReport.BuildSarifIssue(&summary.Queries[idx])
			if x != "" {
				auxID = append(auxID, x)
				guid := sarifReport.GetGUIDFromRelationships(idx, x)
				auxGUID[x] = guid
			}
		}
		sarifReport.AddTags(&summary, &sciInfo.DiffAware)
		sarifReport.RebuildTaxonomies(auxID, auxGUID)
		body = sarifReport
	}

	return ExportJSONReport(path, filename, body)
}

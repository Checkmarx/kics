package model

import "github.com/Checkmarx/kics/v2/pkg/model"

// CSVReport struct contains all the info to create the csv report
type CSVReport struct {
	QueryName                   string `csv:"query_name"`
	QueryID                     string `csv:"query_id"`
	QueryURI                    string `csv:"query_uri"`
	Severity                    string `csv:"severity"`
	Platform                    string `csv:"platform"`
	CWE                         string `csv:"cwe,omitempty"`
	CloudProvider               string `csv:"cloud_provider"`
	Category                    string `csv:"category"`
	DescriptionID               string `csv:"description_id"`
	Description                 string `csv:"description"`
	CISDescriptionIDFormatted   string `csv:"cis_description_id"`
	CISDescriptionTitle         string `csv:"cis_description_title"`
	CISDescriptionTextFormatted string `csv:"cis_description_text"`
	FileName                    string `csv:"file_name"`
	SimilarityID                string `csv:"similarity_id"`
	Line                        int    `csv:"line"`
	IssueType                   string `csv:"issue_type"`
	SearchKey                   string `csv:"search_key"`
	SearchLine                  int    `csv:"search_line"`
	SearchValue                 string `csv:"search_value"`
	ExpectedValue               string `csv:"expected_value"`
	ActualValue                 string `csv:"actual_value"`
}

// BuildCSVReport builds the CSV report
func BuildCSVReport(summary *model.Summary) []CSVReport {
	csvReport := []CSVReport{}

	for i := range summary.Queries {
		for j := range summary.Queries[i].Files {
			csvReport = append(csvReport, CSVReport{
				QueryName:                   summary.Queries[i].QueryName,
				QueryID:                     summary.Queries[i].QueryID,
				QueryURI:                    summary.Queries[i].QueryURI,
				Severity:                    string(summary.Queries[i].Severity),
				Platform:                    summary.Queries[i].Platform,
				CWE:                         summary.Queries[i].CWE,
				CloudProvider:               summary.Queries[i].CloudProvider,
				Category:                    summary.Queries[i].Category,
				DescriptionID:               summary.Queries[i].DescriptionID,
				Description:                 summary.Queries[i].Description,
				CISDescriptionIDFormatted:   summary.Queries[i].CISDescriptionIDFormatted,
				CISDescriptionTitle:         summary.Queries[i].CISDescriptionTitle,
				CISDescriptionTextFormatted: summary.Queries[i].CISDescriptionTextFormatted,
				FileName:                    summary.Queries[i].Files[j].FileName,
				SimilarityID:                summary.Queries[i].Files[j].SimilarityID,
				Line:                        summary.Queries[i].Files[j].Line,
				IssueType:                   string(summary.Queries[i].Files[j].IssueType),
				SearchKey:                   summary.Queries[i].Files[j].SearchKey,
				SearchLine:                  summary.Queries[i].Files[j].SearchLine,
				SearchValue:                 summary.Queries[i].Files[j].SearchValue,
				ExpectedValue:               summary.Queries[i].Files[j].KeyExpectedValue,
				ActualValue:                 summary.Queries[i].Files[j].KeyActualValue,
			})
		}
	}

	return csvReport
}

package model

import "github.com/Checkmarx/kics/pkg/model"

// CSVReport struct contains all the info to create the csv report
type CSVReport struct {
	QueryName                   string `csv:"query_name"`
	QueryID                     string `csv:"query_id"`
	QueryURI                    string `csv:"query_uri"`
	Severity                    string `csv:"severity"`
	Platform                    string `csv:"platform"`
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

	for _, query := range summary.Queries {
		for _, file := range query.Files {
			csvReport = append(csvReport, CSVReport{
				QueryName:                   query.QueryName,
				QueryID:                     query.QueryID,
				QueryURI:                    query.QueryURI,
				Severity:                    string(query.Severity),
				Platform:                    query.Platform,
				CloudProvider:               query.CloudProvider,
				Category:                    query.Category,
				DescriptionID:               query.DescriptionID,
				Description:                 query.Description,
				CISDescriptionIDFormatted:   query.CISDescriptionIDFormatted,
				CISDescriptionTitle:         query.CISDescriptionTitle,
				CISDescriptionTextFormatted: query.CISDescriptionTextFormatted,
				FileName:                    file.FileName,
				SimilarityID:                file.SimilarityID,
				Line:                        file.Line,
				IssueType:                   string(file.IssueType),
				SearchKey:                   file.SearchKey,
				SearchLine:                  file.SearchLine,
				SearchValue:                 file.SearchValue,
				ExpectedValue:               file.KeyExpectedValue,
				ActualValue:                 file.KeyActualValue,
			})
		}
	}

	return csvReport
}

package model

import (
	"github.com/checkmarxDev/ice/pkg/model"
)

type ResultItem struct {
	ID               int             `json:"id"`
	FileName         string          `json:"fileName"`
	QueryID          string          `json:"queryID"`
	QueryName        string          `json:"queryName"`
	Severity         model.Severity  `json:"severity"`
	Line             int             `json:"line"`
	IssueType        model.IssueType `json:"issueType"`
	SearchKey        string          `json:"searchKey"`
	KeyExpectedValue string          `json:"expectedValue"`
	KeyActualValue   string          `json:"actualValue"`
	Value            *string         `json:"value"`
}

func BuildResultItems(vulnerabilities []model.Vulnerability) []ResultItem {
	res := make([]ResultItem, len(vulnerabilities))
	for i := range vulnerabilities {
		vulnerability := vulnerabilities[i]

		res[i] = ResultItem{
			ID:               vulnerability.ID,
			FileName:         vulnerability.FileName,
			QueryID:          vulnerability.QueryID,
			QueryName:        vulnerability.QueryName,
			Severity:         vulnerability.Severity,
			Line:             vulnerability.Line,
			IssueType:        vulnerability.IssueType,
			SearchKey:        vulnerability.SearchKey,
			KeyExpectedValue: vulnerability.KeyExpectedValue,
			KeyActualValue:   vulnerability.KeyActualValue,
			Value:            vulnerability.Value,
		}
	}

	return res
}

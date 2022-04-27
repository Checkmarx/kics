package model

import "github.com/Checkmarx/kics/pkg/model"

type lines struct {
	Begin int `json:"begin"`
}

type location struct {
	Path  string `json:"path"`
	Lines lines  `json:"lines"`
}

type CodeQualityReport struct {
	Type        string   `json:"type"`
	CheckName   string   `json:"check_name"`
	Description string   `json:"description"`
	Categories  []string `json:"categories"`
	Location    location `json:"location"`
	Severity    string   `json:"severity"`
	Fingerprint string   `json:"fingerprint"`
}

var severityMap = map[string]string{
	model.SeverityTrace:  "info",
	model.SeverityInfo:   "info",
	model.SeverityLow:    "minor",
	model.SeverityMedium: "major",
	model.SeverityHigh:   "critical",
}

func BuildCodeQualityReport(summary *model.Summary) []CodeQualityReport {
	var codeQualityReport []CodeQualityReport

	for i := range summary.Queries {
		for j := range summary.Queries[i].Files {
			codeQualityReport = append(codeQualityReport, CodeQualityReport{
				Type:        "issue",
				CheckName:   summary.Queries[i].QueryName,
				Description: summary.Queries[i].Description,
				Categories:  []string{"Security"},
				Location: location{
					Path:  summary.Queries[i].Files[j].FileName,
					Lines: lines{Begin: summary.Queries[i].Files[j].Line},
				},
				Severity:    severityMap[string(summary.Queries[i].Severity)],
				Fingerprint: summary.Queries[i].Files[j].SimilarityID,
			})
		}
	}

	return codeQualityReport
}

package model

import "github.com/Checkmarx/kics/v2/pkg/model"

type lines struct {
	Begin int `json:"begin"`
}

type location struct {
	Path  string `json:"path"`
	Lines lines  `json:"lines"`
}

// CodeClimateReport struct contains all the info to create the code climate report
type CodeClimateReport struct {
	Type        string   `json:"type"`
	CheckName   string   `json:"check_name"`
	CWE         string   `json:"cwe,omitempty"`
	Description string   `json:"description"`
	Categories  []string `json:"categories"`
	Location    location `json:"location"`
	Severity    string   `json:"severity"`
	Fingerprint string   `json:"fingerprint"`
}

var severityMap = map[string]string{
	model.SeverityTrace:    "info",
	model.SeverityInfo:     "info",
	model.SeverityLow:      "minor",
	model.SeverityMedium:   "major",
	model.SeverityHigh:     "critical",
	model.SeverityCritical: "blocker",
}

// BuildCodeClimateReport builds the code climate report
func BuildCodeClimateReport(summary *model.Summary) []CodeClimateReport {
	var codeClimateReport []CodeClimateReport

	for i := range summary.Queries {
		for j := range summary.Queries[i].Files {
			codeClimateReport = append(codeClimateReport, CodeClimateReport{
				Type:        "issue",
				CheckName:   summary.Queries[i].QueryName,
				CWE:         summary.Queries[i].CWE,
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

	return codeClimateReport
}

package model

import (
	"testing"
	"time"

	"github.com/Checkmarx/kics/internal/constants"
	"github.com/Checkmarx/kics/pkg/model"
	"github.com/stretchr/testify/require"
)

// TestNewGitlabSASTReport tests if creates a gitlab sast report correctly
func TestNewGitlabSASTReport(t *testing.T) {
	start := time.Date(2021, time.May, 25, 8, 0, 0, 0, time.UTC)
	end := time.Date(2021, time.May, 25, 8, 1, 0, 0, time.UTC)
	glSAST := NewGitlabSASTReport(start, end).(*gitlabSASTReport)
	require.Equal(
		t,
		"https://gitlab.com/gitlab-org/security-products/security-report-schemas/-/raw/v15.0.6/dist/sast-report-format.json",
		glSAST.Schema,
	)
	require.Equal(t, "15.0.6", glSAST.SchemaVersion)
	require.Equal(t, constants.Fullname, glSAST.Scan.Scanner.Name)
	require.Equal(t, constants.URL, glSAST.Scan.Scanner.URL)
	require.Equal(t, end.Format(timeFormat), glSAST.Scan.EndTime)
	require.Equal(t, start.Format(timeFormat), glSAST.Scan.StartTime)
}

type gitlabSASTTest struct {
	name string
	vq   model.QueryResult
	file model.VulnerableFile
	want gitlabSASTReport
}

var tests = []gitlabSASTTest{
	{
		name: "Should not create any rule",
		vq: model.QueryResult{
			QueryName:   "test",
			QueryID:     "1",
			Description: "test description",
			QueryURI:    "https://www.test.com",
			Severity:    model.SeverityHigh,
			Files:       []model.VulnerableFile{},
		},
		file: model.VulnerableFile{},
		want: gitlabSASTReport{
			Vulnerabilities: make([]gitlabSASTVulnerability, 0),
		},
	},
	{
		name: "Should create one occurrence",
		vq: model.QueryResult{
			QueryName:   "test",
			QueryID:     "1",
			Description: "test description",
			QueryURI:    "https://www.test.com",
			Severity:    model.SeverityHigh,
			Files: []model.VulnerableFile{
				{KeyActualValue: "test", FileName: "test.json", Line: 1, SimilarityID: "similarity"},
			},
		},
		file: model.VulnerableFile{
			KeyActualValue: "test",
			FileName:       "test.json",
			Line:           1,
			SimilarityID:   "similarity",
		},
		want: gitlabSASTReport{
			Vulnerabilities: []gitlabSASTVulnerability{
				{
					ID:       "similarity",
					Severity: "High",
					Name:     "test",
					Links: []gitlabSASTVulnerabilityLink{
						{
							URL: "https://www.test.com",
						},
					},
					Location: gitlabSASTVulnerabilityLocation{
						File:  "test.json",
						Start: 1,
						End:   1,
					},
					Identifiers: []gitlabSASTVulnerabilityIdentifier{
						{
							IdentifierType: "kics",
							Name:           "Keeping Infrastructure as Code Secure",
							URL:            "https://docs.kics.io/latest/queries/-queries",
							Value:          "1",
						},
					},
				},
			},
		},
	},
}

func TestBuildGitlabSASTVulnerability(t *testing.T) {
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			result := NewGitlabSASTReport(time.Now(), time.Now()).(*gitlabSASTReport)
			result.BuildGitlabSASTVulnerability(&tt.vq, &tt.file)
			require.Equal(t, tt.want.Vulnerabilities, result.Vulnerabilities)
		})
	}
}

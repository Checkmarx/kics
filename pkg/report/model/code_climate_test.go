package model

import (
	"testing"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/test"
	"github.com/stretchr/testify/require"
)

func TestBuildCodeClimateReport(t *testing.T) {
	tests := []struct {
		name    string
		summary model.Summary
		want    []CodeClimateReport
	}{
		{
			name:    "build code climate report",
			summary: test.SummaryMock,
			want: []CodeClimateReport{
				{
					Type:        "issue",
					CheckName:   "ALB protocol is HTTP",
					Description: "ALB protocol is HTTP Description",
					Categories:  []string{"Security"},
					Location: location{
						Path:  "positive.tf",
						Lines: lines{Begin: 19},
					},
					Severity: "critical",
					CWE:      "",
				},
				{
					Type:        "issue",
					CheckName:   "ALB protocol is HTTP",
					Description: "ALB protocol is HTTP Description",
					Categories:  []string{"Security"},
					Location: location{
						Path:  "positive.tf",
						Lines: lines{Begin: 25},
					},
					Severity: "critical",
					CWE:      "",
				},
			},
		},
		{
			name:    "build code climate report with cwe field complete",
			summary: test.SummaryMockCWE,
			want: []CodeClimateReport{
				{
					Type:        "issue",
					CheckName:   "AMI Not Encrypted",
					Description: "AWS AMI Encryption is not enabled",
					Categories:  []string{"Security"},
					Location: location{
						Path:  "positive.tf",
						Lines: lines{Begin: 35},
					},
					Severity: "critical",
					CWE:      "22",
				},
				{
					Type:        "issue",
					CheckName:   "AMI Not Encrypted",
					Description: "AWS AMI Encryption is not enabled",
					Categories:  []string{"Security"},
					Location: location{
						Path:  "positive.tf",
						Lines: lines{Begin: 30},
					},
					Severity: "critical",
					CWE:      "22",
				},
			},
		},
	}

	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			report := BuildCodeClimateReport(&test.summary)
			require.Equal(t, test.want, report)
		})
	}
}

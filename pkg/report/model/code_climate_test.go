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
			name:    "build code climate report with high severity",
			summary: test.SummaryMock,
			want: []CodeClimateReport{
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
				},
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
				},
			},
		},
		{
			name:    "build code climate report with critical severity",
			summary: test.SummaryMockCritical,
			want: []CodeClimateReport{
				{
					Type:        "issue",
					CheckName:   "AmazonMQ Broker Encryption Disabled",
					Description: "AmazonMQ Broker should have Encryption Options defined",
					Categories:  []string{"Security"},
					Location: location{
						Path:  "positive1.yaml",
						Lines: lines{Begin: 6},
					},
					Severity: "blocker",
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

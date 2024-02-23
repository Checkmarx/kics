package model

import (
	"testing"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/test"
	"github.com/stretchr/testify/require"
)

func TestBuildCSVReport(t *testing.T) {
	tests := []struct {
		name    string
		summary model.Summary
		want    []CSVReport
	}{
		{
			name:    "build csv report",
			summary: test.SummaryMock,
			want: []CSVReport{
				{
					QueryName:                   "ALB protocol is HTTP",
					QueryID:                     "de7f5e83-da88-4046-871f-ea18504b1d43",
					Severity:                    model.SeverityHigh,
					CWE:                         "",
					DescriptionID:               "504b1d43",
					Description:                 "ALB protocol is HTTP Description",
					CISDescriptionIDFormatted:   "testCISID",
					CISDescriptionTitle:         "testCISTitle",
					CISDescriptionTextFormatted: "testCISDescription",
					FileName:                    "positive.tf",
					Line:                        19,
					IssueType:                   "IncorrectValue",
					SearchKey:                   "aws_alb_listener[front_end].default_action.redirect",
					ExpectedValue:               "'default_action.redirect.protocol' is equal 'HTTPS'",
					ActualValue:                 "'default_action.redirect.protocol' is equal 'HTTP'",
				},
				{
					QueryName:                   "ALB protocol is HTTP",
					QueryID:                     "de7f5e83-da88-4046-871f-ea18504b1d43",
					Severity:                    model.SeverityHigh,
					CWE:                         "",
					DescriptionID:               "504b1d43",
					Description:                 "ALB protocol is HTTP Description",
					CISDescriptionIDFormatted:   "testCISID",
					CISDescriptionTitle:         "testCISTitle",
					CISDescriptionTextFormatted: "testCISDescription",
					FileName:                    "positive.tf",
					Line:                        25,
					IssueType:                   "MissingAttribute",
					SearchKey:                   "aws_alb_listener[front_end].default_action.redirect",
					ExpectedValue:               "'default_action.redirect.protocol' is equal 'HTTPS'",
					ActualValue:                 "'default_action.redirect.protocol' is missing",
				},
			},
		},
		{
			name:    "build csv report cwe field complete",
			summary: test.SummaryMockCWE,
			want: []CSVReport{
				{
					QueryName:                   "AMI Not Encrypted",
					QueryID:                     "97707503-a22c-4cd7-b7c0-f088fa7cf830",
					Severity:                    model.SeverityHigh,
					CWE:                         "22",
					DescriptionID:               "a4342f0",
					Description:                 "AWS AMI Encryption is not enabled",
					CISDescriptionIDFormatted:   "testCISID",
					CISDescriptionTitle:         "testCISTitle",
					CISDescriptionTextFormatted: "testCISDescription",
					FileName:                    "positive.tf",
					Line:                        30,
					IssueType:                   "MissingAttribute",
					SearchKey:                   "aws_alb_listener[front_end].default_action.redirect",
					ExpectedValue:               "'default_action.redirect.protocol' is equal 'HTTPS'",
					ActualValue:                 "'default_action.redirect.protocol' is missing",
				},
				{
					QueryName:                   "AMI Not Encrypted",
					QueryID:                     "97707503-a22c-4cd7-b7c0-f088fa7cf830",
					Severity:                    model.SeverityHigh,
					CWE:                         "22",
					DescriptionID:               "a4342f0",
					Description:                 "AWS AMI Encryption is not enabled",
					CISDescriptionIDFormatted:   "testCISID",
					CISDescriptionTitle:         "testCISTitle",
					CISDescriptionTextFormatted: "testCISDescription",
					FileName:                    "positive.tf",
					Line:                        35,
					IssueType:                   "IncorrectValue",
					SearchKey:                   "aws_alb_listener[front_end].default_action.redirect",
					ExpectedValue:               "'default_action.redirect.protocol' is equal 'HTTPS'",
					ActualValue:                 "'default_action.redirect.protocol' is equal 'HTTP'",
				},
			},
		},
	}

	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			report := BuildCSVReport(&test.summary)
			require.Equal(t, test.want, report)
		})
	}
}

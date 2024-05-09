package model

import (
	"testing"

	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/Checkmarx/kics/v2/test"
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
					Line:                        25,
					IssueType:                   "MissingAttribute",
					SearchKey:                   "aws_alb_listener[front_end].default_action.redirect",
					ExpectedValue:               "'default_action.redirect.protocol' is equal 'HTTPS'",
					ActualValue:                 "'default_action.redirect.protocol' is missing",
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
					Line:                        19,
					IssueType:                   "IncorrectValue",
					SearchKey:                   "aws_alb_listener[front_end].default_action.redirect",
					ExpectedValue:               "'default_action.redirect.protocol' is equal 'HTTPS'",
					ActualValue:                 "'default_action.redirect.protocol' is equal 'HTTP'",
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
					QueryURI:                    "",
					Severity:                    "HIGH",
					Platform:                    "",
					CWE:                         "22",
					CloudProvider:               "",
					Category:                    "",
					DescriptionID:               "a4342f0",
					Description:                 "AWS AMI Encryption is not enabled",
					CISDescriptionIDFormatted:   "testCISID",
					CISDescriptionTitle:         "testCISTitle",
					CISDescriptionTextFormatted: "testCISDescription",
					FileName:                    "positive.tf",
					SimilarityID:                "",
					Line:                        35,
					IssueType:                   "IncorrectValue",
					SearchKey:                   "aws_alb_listener[front_end].default_action.redirect",
					SearchLine:                  0,
					SearchValue:                 "",
					ExpectedValue:               "'default_action.redirect.protocol' is equal 'HTTPS'",
					ActualValue:                 "'default_action.redirect.protocol' is equal 'HTTP'",
				},
			},
		},
		{
			name:    "build csv report critical",
			summary: test.SummaryMockCritical,
			want: []CSVReport{
				{
					QueryName:                   "AmazonMQ Broker Encryption Disabled",
					QueryID:                     "316278b3-87ac-444c-8f8f-a733a28da609",
					Severity:                    model.SeverityCritical,
					DescriptionID:               "c5d562d9",
					Description:                 "AmazonMQ Broker should have Encryption Options defined",
					CloudProvider:               "AWS",
					CISDescriptionIDFormatted:   "testCISID",
					CISDescriptionTitle:         "testCISTitle",
					CISDescriptionTextFormatted: "testCISDescription",
					FileName:                    "test/fixtures/test_critical_custom_queries/amazon_mq_broker_encryption_disabled/test/positive1.yaml",
					Line:                        6,
					IssueType:                   "MissingAttribute",
					SearchKey:                   "aws_alb_listener[front_end].default_action.redirect",
					ExpectedValue:               "'default_action.redirect.protocol' is equal 'HTTPS'",
					ActualValue:                 "'default_action.redirect.protocol' is missing",
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

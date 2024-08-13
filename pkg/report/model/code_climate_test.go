/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache-2.0 License.
 *
 * This product includes software developed at Datadog (https://www.datadoghq.com)  Copyright 2024 Datadog, Inc.
 */
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
					CWE:      "",
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
						Lines: lines{Begin: 30},
					},
					Severity: "critical",
					CWE:      "22",
				},
				{
					Type:        "issue",
					CheckName:   "AMI Not Encrypted",
					CWE:         "22",
					Description: "AWS AMI Encryption is not enabled",
					Categories:  []string{"Security"},
					Location: location{
						Path:  "positive.tf",
						Lines: lines{Begin: 35},
					},
					Severity:    "critical",
					Fingerprint: "",
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
						Path:  "test/fixtures/test_critical_custom_queries/amazon_mq_broker_encryption_disabled/test/positive1.yaml",
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

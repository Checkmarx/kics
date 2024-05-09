package model

import (
	"reflect"
	"testing"
	"time"

	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/Checkmarx/kics/v2/test"
	"github.com/aws/aws-sdk-go-v2/aws"
)

// TestBuildASFFReport tests the BuildASFFReport function
func TestBuildASFFReport(t *testing.T) {
	awsSecurityFinding := AwsSecurityFinding{
		AwsAccountID: *aws.String("AWS_ACCOUNT_ID"),
		CreatedAt:    *aws.String(time.Now().Format(time.RFC3339)),
		Description:  *aws.String("AmazonMQ Broker should have Encryption Options defined"),
		GeneratorID:  *aws.String("3db3f534-e3a3-487f-88c7-0a9fbf64b702"),
		ID:           *aws.String("AWS_REGION/AWS_ACCOUNT_ID/6b76f7a507e200bb2c73468ec9649b099da96a4efa0f49a3bdc88e12476d8ee7"),
		ProductArn:   *aws.String("arn:aws:securityhub:AWS_REGION:AWS_ACCOUNT_ID:product/AWS_ACCOUNT_ID/default"),
		Resources: []Resource{
			{
				ID:   *aws.String("3db3f534-e3a3-487f-88c7-0a9fbf64b702"),
				Type: *aws.String("Other"),
			},
		},
		SchemaVersion: *aws.String("2018-10-08"),
		Severity: Severity{
			Original: *aws.String("MEDIUM"),
			Label:    *aws.String("MEDIUM"),
		},
		Title:     *aws.String("AmazonMQ Broker Encryption Disabled"),
		Types:     []string{*aws.String("Software and Configuration Checks/Vulnerabilities/KICS")},
		UpdatedAt: *aws.String(time.Now().Format(time.RFC3339)),
		Remediation: Remediation{
			Recommendation: AsffRecommendation{
				Text: *aws.String("Problem found on 'positive.tf' file in line 1. Expected value: resource.aws_mq_broker[positive1].encryption_options is defined. Actual value: resource.aws_mq_broker[positive1].encryption_options is not defined."),
			},
		},
		Compliance: Compliance{Status: *aws.String("FAILED")},
		CWE:        "",
	}

	awsSecurityFinding2 := AwsSecurityFinding{
		AwsAccountID: *aws.String("AWS_ACCOUNT_ID"),
		CreatedAt:    *aws.String(time.Now().Format(time.RFC3339)),
		Description:  *aws.String("AmazonMQ Broker should have Encryption Options defined"),
		GeneratorID:  *aws.String("3db3f534-e3a3-487f-88c7-0a9fbf64b702"),
		ID:           *aws.String("AWS_REGION/AWS_ACCOUNT_ID/6b76f7a507e200bb2c73468ec9649b099da96a4efa0f49a3bdc88e12476d8ee7"),
		ProductArn:   *aws.String("arn:aws:securityhub:AWS_REGION:AWS_ACCOUNT_ID:product/AWS_ACCOUNT_ID/default"),
		Resources: []Resource{
			{
				ID:   *aws.String("3db3f534-e3a3-487f-88c7-0a9fbf64b702"),
				Type: *aws.String("Other"),
			},
		},
		SchemaVersion: *aws.String("2018-10-08"),
		Severity: Severity{
			Original: *aws.String("MEDIUM"),
			Label:    *aws.String("MEDIUM"),
		},
		Title:     *aws.String("AmazonMQ Broker Encryption Disabled"),
		Types:     []string{*aws.String("Software and Configuration Checks/Vulnerabilities/KICS")},
		UpdatedAt: *aws.String(time.Now().Format(time.RFC3339)),
		Remediation: Remediation{
			Recommendation: AsffRecommendation{
				Text: *aws.String("Problem found on 'positive.tf' file in line 1. Expected value: resource.aws_mq_broker[positive1].encryption_options is defined. Actual value: resource.aws_mq_broker[positive1].encryption_options is not defined."),
			},
		},
		Compliance: Compliance{Status: *aws.String("FAILED")},
		CWE:        "22",
	}

	awsSecurityFinding3 := AwsSecurityFinding{
		AwsAccountID: *aws.String("AWS_ACCOUNT_ID"),
		CreatedAt:    *aws.String(time.Now().Format(time.RFC3339)),
		Description:  *aws.String("AmazonMQ Broker should have Encryption Options defined"),
		GeneratorID:  *aws.String("316278b3-87ac-444c-8f8f-a733a28da609"),
		ID:           *aws.String("AWS_REGION/AWS_ACCOUNT_ID/e5b6a100ab6a12e2a71d68827e664068ab29ef06f4b4e48d80019ef68e945e38"),
		ProductArn:   *aws.String("arn:aws:securityhub:AWS_REGION:AWS_ACCOUNT_ID:product/AWS_ACCOUNT_ID/default"),
		Resources: []Resource{
			{
				ID:   *aws.String("316278b3-87ac-444c-8f8f-a733a28da609"),
				Type: *aws.String("Other"),
			},
		},
		SchemaVersion: *aws.String("2018-10-08"),
		Severity: Severity{
			Original: *aws.String("CRITICAL"),
			Label:    *aws.String("CRITICAL"),
		},
		Title:     *aws.String("AmazonMQ Broker Encryption Disabled"),
		Types:     []string{*aws.String("Software and Configuration Checks/Vulnerabilities/KICS")},
		UpdatedAt: *aws.String(time.Now().Format(time.RFC3339)),

		Remediation: Remediation{
			Recommendation: AsffRecommendation{
				Text: *aws.String("Problem found on 'test/fixtures/test_critical_custom_queries/amazon_mq_broker_encryption_disabled/test/positive1.yaml' file in line 6. Expected value: 'default_action.redirect.protocol' is equal 'HTTPS'. Actual value: 'default_action.redirect.protocol' is missing."),
			},
		},
		Compliance: Compliance{Status: *aws.String("FAILED")},
		CWE:        "22",
	}
	var awsSecurityFindings []AwsSecurityFinding
	var awsSecurityFindings2 []AwsSecurityFinding
	var awsSecurityFindings3 []AwsSecurityFinding

	awsSecurityFindings = append(awsSecurityFindings, awsSecurityFinding)
	awsSecurityFindings2 = append(awsSecurityFindings2, awsSecurityFinding2)
	awsSecurityFindings3 = append(awsSecurityFindings3, awsSecurityFinding3)

	type args struct {
		summary *model.Summary
	}
	tests := []struct {
		name string
		args args
		want []AwsSecurityFinding
	}{
		{
			name: "Build ASFF",
			args: args{
				summary: &test.SimpleSummaryMock,
			},
			want: awsSecurityFindings,
		},
		{
			name: "Build ASFF with critical severity",
			args: args{
				summary: &test.SummaryMockCriticalFullPathASFF,
			},
			want: awsSecurityFindings3,
		},
		{
			name: "Build ASFF with CWE",
			args: args{
				summary: &test.SimpleSummaryMockAsff,
			},
			want: awsSecurityFindings2,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if tt.name == "Build ASFF" || tt.name == "Build ASFF with CWE" {
				got := BuildASFF(tt.args.summary)

				if len(got) == 0 {
					t.Errorf("BuildASFF returned an empty slice for test case %s", tt.name)
				}

				got[0].AwsAccountID = "AWS_ACCOUNT_ID"
				got[0].ProductArn = "arn:aws:securityhub:AWS_REGION:AWS_ACCOUNT_ID:product/AWS_ACCOUNT_ID/default"
				got[0].ID = "AWS_REGION/AWS_ACCOUNT_ID/6b76f7a507e200bb2c73468ec9649b099da96a4efa0f49a3bdc88e12476d8ee7"
				if !reflect.DeepEqual(got, tt.want) {
					t.Errorf("BuildASFF() = %v, want %v", got, tt.want)
				}
			} else if tt.name == "Build ASFF with critical severity" {
				got := BuildASFF(tt.args.summary)

				if len(got) == 0 {
					t.Errorf("BuildASFF with critical severity returned an empty slice for test case %s", tt.name)
				}

				got[0].AwsAccountID = "AWS_ACCOUNT_ID"
				got[0].ProductArn = "arn:aws:securityhub:AWS_REGION:AWS_ACCOUNT_ID:product/AWS_ACCOUNT_ID/default"
				got[0].ID = "AWS_REGION/AWS_ACCOUNT_ID/e5b6a100ab6a12e2a71d68827e664068ab29ef06f4b4e48d80019ef68e945e38"
				if !reflect.DeepEqual(got, tt.want) {
					t.Errorf("BuildASFF with critical severity() = %v\n, want %v", got, tt.want)
				}
			}
		})

	}

}

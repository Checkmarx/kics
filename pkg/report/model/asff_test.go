package model

import (
	"reflect"
	"testing"
	"time"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/test"
	"github.com/aws/aws-sdk-go/aws"
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
				Text: *aws.String("In line 1 of file (positive.tf), a result was found. resource.aws_mq_broker[positive1].encryption_options is not defined, but resource.aws_mq_broker[positive1].encryption_options is defined"),
			},
		},
		Compliance: Compliance{Status: *aws.String("FAILED")},
	}

	var awsSecurityFindings []AwsSecurityFinding

	awsSecurityFindings = append(awsSecurityFindings, awsSecurityFinding)

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
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := BuildASFF(tt.args.summary)
			got[0].AwsAccountID = "AWS_ACCOUNT_ID"
			got[0].ProductArn = "arn:aws:securityhub:AWS_REGION:AWS_ACCOUNT_ID:product/AWS_ACCOUNT_ID/default"
			got[0].ID = "AWS_REGION/AWS_ACCOUNT_ID/6b76f7a507e200bb2c73468ec9649b099da96a4efa0f49a3bdc88e12476d8ee7"
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("BuildASFF() = %v, want %v", got, tt.want)
			}
		})
	}

}

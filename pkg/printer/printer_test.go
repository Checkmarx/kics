package printer

import (
	"fmt"
	"os"
	"path/filepath"
	"reflect"
	"testing"

	"github.com/Checkmarx/kics/v2/internal/console/flags"
	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/Checkmarx/kics/v2/test"
	"github.com/gookit/color"
	"github.com/spf13/cobra"
	"github.com/stretchr/testify/require"
)

func TestPrinter_SetupPrinter(t *testing.T) {
	mockCmd := &cobra.Command{
		Use:   "mock",
		Short: "Mock cmd",
		RunE: func(cmd *cobra.Command, args []string) error {
			return nil
		},
	}

	data, err := os.ReadFile(filepath.FromSlash("../../internal/console/assets/kics-flags.json"))
	require.NoError(t, err)
	flags.InitJSONFlags(mockCmd, string(data), false, []string{"terraform"}, []string{"aws"})

	err = SetupPrinter(mockCmd.Flags())
	require.NoError(t, err)
	require.True(t, IsInitialized())
}

func TestPrinter(t *testing.T) {
	type args struct {
		content string
		sev     string
	}

	tests := []struct {
		name string
		args args
		want string
	}{
		{
			name: "test_critical",
			args: args{
				content: "test_critical_content",
				sev:     model.SeverityCritical,
			},
			want: "test_critical_content",
		},
		{
			name: "test_high",
			args: args{
				content: "test_high_content",
				sev:     model.SeverityHigh,
			},
			want: "test_high_content",
		},
		{
			name: "test_medium",
			args: args{
				content: "test_medium_content",
				sev:     model.SeverityMedium,
			},
			want: "test_medium_content",
		},
		{
			name: "test_low",
			args: args{
				content: "test_low_content",
				sev:     model.SeverityLow,
			},
			want: "test_low_content",
		},
		{
			name: "test_info",
			args: args{
				content: "test_info_content",
				sev:     model.SeverityInfo,
			},
			want: "test_info_content",
		},
		{
			name: "test_no_sev_content",
			args: args{
				content: "test_no_sev_content",
				sev:     "no_sev",
			},
			want: "test_no_sev_content",
		},
	}

	printer := NewPrinter(false)
	color.Disable()
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := printer.PrintBySev(tt.args.content, tt.args.sev)
			gotStrVulnerabilities, err := test.StringifyStruct(got)
			require.Nil(t, err)
			wantStrVulnerabilities, err := test.StringifyStruct(tt.want)
			require.Nil(t, err)
			if !reflect.DeepEqual(gotStrVulnerabilities, wantStrVulnerabilities) {
				t.Errorf("PrintBySev() = %v, want = %v", gotStrVulnerabilities, wantStrVulnerabilities)
			}
		})
	}
}

var printTests = []struct {
	caseTest           model.Summary
	expectedResult     string
	expectedResultFull string
	customQueries      bool
}{

	{
		caseTest:           test.ComplexSummaryMock,
		expectedResult:     "\n\nRun Block Injection, Severity: CRITICAL, Results: 1\n\t[1]: positive.tf:10\nAMI Not Encrypted, Severity: HIGH, Results: 2\n\t[1]: positive.tf:30\n\t[2]: positive.tf:35\nAmazonMQ Broker Encryption Disabled, Severity: MEDIUM, Results: 1\n\t[1]: positive.tf:1\nALB protocol is HTTP, Severity: HIGH, Results: 2\n\t[1]: positive.tf:25\n\t[2]: positive.tf:19\n\nResults Summary:\nCRITICAL: 2\nHIGH: 2\nMEDIUM: 1\nLOW: 0\nINFO: 0\nTOTAL: 5\n\n",
		expectedResultFull: "\n\nRun Block Injection, Severity: CRITICAL, Results: 1\nDescription: GitHub Actions workflows can be triggered by a variety of events. Every workflow trigger is provided with a GitHub context that contains information about the triggering event, such as which user triggered it, the branch name, and other event context details. Some of this event data, like the base repository name, hash value of a changeset, or pull request number, is unlikely to be controlled or used for injection by the user that triggered the event.\nPlatform: \nLearn more about this vulnerability: https://docs.kics.io/latest/queries/-queries/20f14e1a-a899-4e79-9f09-b6a84cd4649b\n\n\t[1]: positive.tf:10\n\n\n\nAMI Not Encrypted, Severity: HIGH, Results: 2\nDescription: AWS AMI Encryption is not enabled\nPlatform: \nCWE: 22\nLearn more about this vulnerability: https://docs.kics.io/latest/queries/-queries/97707503-a22c-4cd7-b7c0-f088fa7cf830\n\n\t[1]: positive.tf:30\n\n\n\n\t[2]: positive.tf:35\n\n\n\nAmazonMQ Broker Encryption Disabled, Severity: MEDIUM, Results: 1\nDescription: AmazonMQ Broker should have Encryption Options defined\nPlatform: \nLearn more about this vulnerability: https://docs.kics.io/latest/queries/-queries/aws/3db3f534-e3a3-487f-88c7-0a9fbf64b702\n\n\t[1]: positive.tf:1\n\n\n\nALB protocol is HTTP, Severity: HIGH, Results: 2\nDescription: ALB protocol is HTTP Description\nPlatform: \nLearn more about this vulnerability: https://docs.kics.io/latest/queries/-queries/de7f5e83-da88-4046-871f-ea18504b1d43\n\n\t[1]: positive.tf:25\n\n\n\n\t[2]: positive.tf:19\n\n\n\n\nResults Summary:\nCRITICAL: 2\nHIGH: 2\nMEDIUM: 1\nLOW: 0\nINFO: 0\nTOTAL: 5\n\n",
		customQueries:      false,
	},
	{
		caseTest:           test.ComplexSummaryMock,
		expectedResult:     "\n\nRun Block Injection, Severity: CRITICAL, Results: 1\n\t[1]: positive.tf:10\nAMI Not Encrypted, Severity: HIGH, Results: 2\n\t[1]: positive.tf:30\n\t[2]: positive.tf:35\nAmazonMQ Broker Encryption Disabled, Severity: MEDIUM, Results: 1\n\t[1]: positive.tf:1\nALB protocol is HTTP, Severity: HIGH, Results: 2\n\t[1]: positive.tf:25\n\t[2]: positive.tf:19\n\nResults Summary:\nCRITICAL: 2\nHIGH: 2\nMEDIUM: 1\nLOW: 0\nINFO: 0\nTOTAL: 5\n\n",
		expectedResultFull: "\n\nRun Block Injection, Severity: CRITICAL, Results: 1\nDescription: GitHub Actions workflows can be triggered by a variety of events. Every workflow trigger is provided with a GitHub context that contains information about the triggering event, such as which user triggered it, the branch name, and other event context details. Some of this event data, like the base repository name, hash value of a changeset, or pull request number, is unlikely to be controlled or used for injection by the user that triggered the event.\nPlatform: \n\t[1]: positive.tf:10\n\n\n\nAMI Not Encrypted, Severity: HIGH, Results: 2\nDescription: AWS AMI Encryption is not enabled\nPlatform: \nCWE: 22\n\t[1]: positive.tf:30\n\n\n\n\t[2]: positive.tf:35\n\n\n\nAmazonMQ Broker Encryption Disabled, Severity: MEDIUM, Results: 1\nDescription: AmazonMQ Broker should have Encryption Options defined\nPlatform: \n\t[1]: positive.tf:1\n\n\n\nALB protocol is HTTP, Severity: HIGH, Results: 2\nDescription: ALB protocol is HTTP Description\nPlatform: \n\t[1]: positive.tf:25\n\n\n\n\t[2]: positive.tf:19\n\n\n\n\nResults Summary:\nCRITICAL: 2\nHIGH: 2\nMEDIUM: 1\nLOW: 0\nINFO: 0\nTOTAL: 5\n\n",
		customQueries:      true,
	},
	{
		caseTest:           test.ComplexSummaryMockWithExperimental,
		expectedResult:     "\n\nAmazonMQ Broker Encryption Disabled, Severity: MEDIUM, Results: 1\n\t[1]: positive.tf:1\nALB protocol is HTTP, Severity: HIGH, Results: 2\nNote: this is an experimental query\n\t[1]: positive.tf:25\n\t[2]: positive.tf:19\n\nResults Summary:\nCRITICAL: 0\nHIGH: 2\nMEDIUM: 1\nLOW: 0\nINFO: 0\nTOTAL: 3\n\n",
		expectedResultFull: "\n\nAmazonMQ Broker Encryption Disabled, Severity: MEDIUM, Results: 1\nDescription: AmazonMQ Broker should have Encryption Options defined\nPlatform: \nLearn more about this vulnerability: https://docs.kics.io/latest/queries/-queries/aws/3db3f534-e3a3-487f-88c7-0a9fbf64b702\n\n\t[1]: positive.tf:1\n\n\n\nALB protocol is HTTP, Severity: HIGH, Results: 2\nNote: this is an experimental query\nDescription: ALB protocol is HTTP Description\nPlatform: \nLearn more about this vulnerability: https://docs.kics.io/latest/queries/-queries/de7f5e83-da88-4046-871f-ea18504b1d43\n\n\t[1]: positive.tf:25\n\n\n\n\t[2]: positive.tf:19\n\n\n\n\nResults Summary:\nCRITICAL: 0\nHIGH: 2\nMEDIUM: 1\nLOW: 0\nINFO: 0\nTOTAL: 3\n\n",
		customQueries:      false,
	},
	{
		caseTest:           test.ExampleSummaryMockWithCloudProviderCommon,
		expectedResult:     "\n\nUnpinned Actions Full Length Commit SHA, Severity: LOW, Results: 1\n\t[1]: positive.tf:12\n\nResults Summary:\nCRITICAL: 0\nHIGH: 0\nMEDIUM: 0\nLOW: 1\nINFO: 0\nTOTAL: 1\n\n",
		expectedResultFull: "\n\nUnpinned Actions Full Length Commit SHA, Severity: LOW, Results: 1\nDescription: Pinning an action to a full length commit SHA is currently the only way to use an action as an immutable release.\nPlatform: CICD\nLearn more about this vulnerability: https://docs.kics.io/latest/queries/cicd-queries/555ab8f9-2001-455e-a077-f2d0f41e2fb9\n\n\t[1]: positive.tf:12\n\n\n\n\nResults Summary:\nCRITICAL: 0\nHIGH: 0\nMEDIUM: 0\nLOW: 1\nINFO: 0\nTOTAL: 1\n\n",
		customQueries:      false,
	},
	{
		caseTest:           test.ExampleSummaryMockWithPasswordsAndSecretsCommonQuery,
		expectedResult:     "\n\nPasswords And Secrets - AWS Secret Key, Severity: HIGH, Results: 1\n\t[1]: positive.tf:15\n\nResults Summary:\nCRITICAL: 0\nHIGH: 1\nMEDIUM: 0\nLOW: 0\nINFO: 0\nTOTAL: 1\n\n",
		expectedResultFull: "\n\nPasswords And Secrets - AWS Secret Key, Severity: HIGH, Results: 1\nDescription: Query to find passwords and secrets in infrastructure code.\nPlatform: Common\nLearn more about this vulnerability: https://docs.kics.io/latest/queries/common-queries/a88baa34-e2ad-44ea-ad6f-8cac87bc7c71\n\n\t[1]: positive.tf:15\n\n\n\n\nResults Summary:\nCRITICAL: 0\nHIGH: 1\nMEDIUM: 0\nLOW: 0\nINFO: 0\nTOTAL: 1\n\n",
		customQueries:      false,
	},
}

// TestPrintResult tests the functions [PrintResult()] and all the methods called by them
func TestPrintResult(t *testing.T) {
	color.Disable()
	for idx, testCase := range printTests {
		t.Run(fmt.Sprintf("Print test case %d", idx), func(t *testing.T) {
			out, err := test.CaptureOutput(func() error {
				return PrintResult(&testCase.caseTest, NewPrinter(true), testCase.customQueries)
			})
			require.NoError(t, err)
			require.Equal(t, testCase.expectedResult, out)
		})
	}

	for idx, testCase := range printTests {
		t.Run(fmt.Sprintf("Print test case %d no minimal", idx), func(t *testing.T) {
			out, err := test.CaptureOutput(func() error {
				return PrintResult(&testCase.caseTest, NewPrinter(false), testCase.customQueries)
			})
			require.NoError(t, err)
			require.Equal(t, testCase.expectedResultFull, out)
		})
	}
}

func TestHelpers_WordWrap(t *testing.T) {
	type args struct {
		s           string
		indentation string
		limit       int
	}

	tests := []struct {
		name string
		args args
		want string
	}{
		{
			name: "test_word_wrap",
			args: args{
				s:           "testing",
				indentation: "-",
				limit:       1,
			},
			want: "-testing\r\n",
		},
		{
			name: "test_word_wrap",
			args: args{
				s:           "",
				indentation: "-",
				limit:       1,
			},
			want: "",
		},
		{
			name: "test_word_wrap",
			args: args{
				s:           "testing string word wrap",
				indentation: "-",
				limit:       2,
			},
			want: "-testing string\r\n-word wrap\r\n",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := WordWrap(tt.args.s, tt.args.indentation, tt.args.limit)
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("WordWrap =\n%v, want = \n%v", got, tt.want)
			}
		})
	}
}

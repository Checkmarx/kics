package printer

import (
	"fmt"
	"os"
	"path/filepath"
	"reflect"
	"testing"

	"github.com/Checkmarx/kics/internal/console/flags"
	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/test"
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
		caseTest: test.ComplexSummaryMock,
		expectedResult: "Files scanned: 2\n" +
			"Parsed files: 2\n" +
			"Queries loaded: 2\n" +
			"Queries failed to execute: 0\n\n" +
			"------------------------------------\n\n" +
			"AmazonMQ Broker Encryption Disabled, Severity: MEDIUM, Results: 1\n" +
			"\t[1]: positive.tf:1\n" +
			"ALB protocol is HTTP, Severity: HIGH, Results: 2\n" +
			"\t[1]: positive.tf:25\n" +
			"\t[2]: positive.tf:19\n\n" +
			"Results Summary:\n" +
			"HIGH: 2\n" +
			"MEDIUM: 1\n" +
			"LOW: 0\n" +
			"INFO: 0\n" +
			"TOTAL: 3\n\n",
		expectedResultFull: "Files scanned: 2\n" +
			"Parsed files: 2\n" +
			"Queries loaded: 2\n" +
			"Queries failed to execute: 0\n\n" +
			"------------------------------------\n\n" +
			"AmazonMQ Broker Encryption Disabled, Severity: MEDIUM, Results: 1\n" +
			"Description: AmazonMQ Broker should have Encryption Options defined\nPlatform: \n" +
			"Learn more about this vulnerability: https://docs.kics.io/latest/queries/-queries/aws/3db3f534-e3a3-487f-88c7-0a9fbf64b702\n\n" +
			"\t[1]: positive.tf:1\n\n\n\n" +
			"ALB protocol is HTTP, Severity: HIGH, Results: 2\n" +
			"Description: ALB protocol is HTTP Description\n" +
			"Platform: \n" +
			"Learn more about this vulnerability: https://docs.kics.io/latest/queries/-queries/de7f5e83-da88-4046-871f-ea18504b1d43\n\n" +
			"\t[1]: positive.tf:25\n\n\n\n" +
			"\t[2]: positive.tf:19\n\n\n\n\n" +
			"Results Summary:\n" +
			"HIGH: 2\n" +
			"MEDIUM: 1\n" +
			"LOW: 0\n" +
			"INFO: 0\n" +
			"TOTAL: 3\n\n",
		customQueries: false,
	},
	{
		caseTest: test.ComplexSummaryMock,
		expectedResult: "Files scanned: 2\n" +
			"Parsed files: 2\n" +
			"Queries loaded: 2\n" +
			"Queries failed to execute: 0\n\n" +
			"------------------------------------\n\n" +
			"AmazonMQ Broker Encryption Disabled, Severity: MEDIUM, Results: 1\n" +
			"\t[1]: positive.tf:1\n" +
			"ALB protocol is HTTP, Severity: HIGH, Results: 2\n" +
			"\t[1]: positive.tf:25\n" +
			"\t[2]: positive.tf:19\n\n" +
			"Results Summary:\n" +
			"HIGH: 2\n" +
			"MEDIUM: 1\n" +
			"LOW: 0\n" +
			"INFO: 0\n" +
			"TOTAL: 3\n\n",
		expectedResultFull: "Files scanned: 2\n" +
			"Parsed files: 2\n" +
			"Queries loaded: 2\n" +
			"Queries failed to execute: 0\n\n" +
			"------------------------------------\n\n" +
			"AmazonMQ Broker Encryption Disabled, Severity: MEDIUM, Results: 1\n" +
			"Description: AmazonMQ Broker should have Encryption Options defined\nPlatform: \n" +
			"\t[1]: positive.tf:1\n\n\n\n" +
			"ALB protocol is HTTP, Severity: HIGH, Results: 2\n" +
			"Description: ALB protocol is HTTP Description\n" +
			"Platform: \n" +
			"\t[1]: positive.tf:25\n\n\n\n" +
			"\t[2]: positive.tf:19\n\n\n\n\n" +
			"Results Summary:\n" +
			"HIGH: 2\n" +
			"MEDIUM: 1\n" +
			"LOW: 0\n" +
			"INFO: 0\n" +
			"TOTAL: 3\n\n",
		customQueries: true,
	},
}

var failedQueries = map[string]error{}

// TestPrintResult tests the functions [PrintResult()] and all the methods called by them
func TestPrintResult(t *testing.T) {
	color.Disable()
	for idx, testCase := range printTests {
		t.Run(fmt.Sprintf("Print test case %d", idx), func(t *testing.T) {
			out, err := test.CaptureOutput(func() error {
				return PrintResult(&testCase.caseTest, failedQueries, NewPrinter(true), testCase.customQueries)
			})
			require.NoError(t, err)
			require.Equal(t, testCase.expectedResult, out)
		})
	}

	for idx, testCase := range printTests {
		t.Run(fmt.Sprintf("Print test case %d no minimal", idx), func(t *testing.T) {
			out, err := test.CaptureOutput(func() error {
				return PrintResult(&testCase.caseTest, failedQueries, NewPrinter(false), testCase.customQueries)
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

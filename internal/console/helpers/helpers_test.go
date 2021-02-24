package helpers

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
	"reflect"
	"strings"
	"sync"
	"testing"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/test"
	"github.com/gookit/color"
	"github.com/stretchr/testify/require"
)

var summary = model.Summary{
	Counters: model.Counters{
		ScannedFiles:           1,
		ParsedFiles:            1,
		FailedToScanFiles:      0,
		TotalQueries:           1,
		FailedToExecuteQueries: 0,
	},
	Queries: []model.VulnerableQuery{
		{
			QueryName: "ALB protocol is HTTP",
			QueryID:   "de7f5e83-da88-4046-871f-ea18504b1d43",
			Severity:  "HIGH",
			Files: []model.VulnerableFile{
				{
					FileName:         "positive.tf",
					Line:             25,
					IssueType:        "MissingAttribute",
					SearchKey:        "aws_alb_listener[front_end].default_action.redirect",
					KeyExpectedValue: "'default_action.redirect.protocol' is equal 'HTTPS'",
					KeyActualValue:   "'default_action.redirect.protocol' is missing",
					Value:            nil,
				},
				{
					FileName:         "positive.tf",
					Line:             19,
					IssueType:        "IncorrectValue",
					SearchKey:        "aws_alb_listener[front_end].default_action.redirect",
					KeyExpectedValue: "'default_action.redirect.protocol' is equal 'HTTPS'",
					KeyActualValue:   "'default_action.redirect.protocol' is equal 'HTTP'",
					Value:            nil,
				},
			},
		},
	},
	SeveritySummary: model.SeveritySummary{
		ScanID: "console",
		SeverityCounters: map[model.Severity]int{
			"INFO":   0,
			"LOW":    0,
			"MEDIUM": 0,
			"HIGH":   2,
		},
		TotalCounter: 2,
	},
}

var printTests = []struct {
	caseTest       model.Summary
	expectedResult string
}{
	{
		caseTest: summary,
		expectedResult: "Files scanned: 1\n" +
			"Parsed files: 1\n" +
			"Queries loaded: 1\n" +
			"Queries failed to execute: 0\n" +
			"------------------------------------\n" +
			"ALB protocol is HTTP, Severity: HIGH, Results: 2\n" +
			"\t[1]: positive.tf:25\n" +
			"\t[2]: positive.tf:19\n\n" +
			"Results Summary:\n" +
			"HIGH: 2\n" +
			"MEDIUM: 0\n" +
			"LOW: 0\n" +
			"INFO: 0\n" +
			"TOTAL: 2\n\n",
	},
}

type jsonCaseTest struct {
	summary model.Summary
	path    string
}

var jsonTests = []struct {
	caseTest       jsonCaseTest
	expectedResult model.Summary
}{
	{
		caseTest: jsonCaseTest{
			summary: summary,
			path:    "./testout.json",
		},
		expectedResult: summary,
	},
}

var failedQueries = map[string]error{}

// TestPrintResult tests the functions [PrintResult()] and all the methods called by them
func TestPrintResult(t *testing.T) {
	color.Disable()
	for idx, testCase := range printTests {
		t.Run(fmt.Sprintf("Print test case %d", idx), func(t *testing.T) {
			out, err := test.CaptureOutput(func() error { return PrintResult(&testCase.caseTest, failedQueries, Printer{}, false) })
			require.NoError(t, err)
			require.Equal(t, testCase.expectedResult, out)
		})
	}
}

// TestPrintToJSONFile tests the functions [PrintToJSONFile()] and all the methods called by them
func TestPrintToJSONFile(t *testing.T) {
	for idx, test := range jsonTests {
		t.Run(fmt.Sprintf("JSON File test case %d", idx), func(t *testing.T) {
			var err error
			err = PrintToJSONFile(test.caseTest.path, test.caseTest.summary)
			require.NoError(t, err)
			require.FileExists(t, test.caseTest.path)
			var jsonResult []byte
			jsonResult, err = ioutil.ReadFile(test.caseTest.path)
			require.NoError(t, err)
			var resultSummary model.Summary
			err = json.Unmarshal(jsonResult, &resultSummary)
			require.NoError(t, err)
			require.Equal(t, test.expectedResult, resultSummary)
			os.Remove(test.caseTest.path)
		})
	}
}

type progressBarTestArgs struct {
	label string
	total float64
	space int
}

var progressBarTests = []struct {
	name              string
	args              progressBarTestArgs
	shouldCheckOutput bool
	want              string
}{
	{
		name: "Should return labeled progressbar with 5 spaces each side",
		args: progressBarTestArgs{
			label: "ProgressTest",
			total: 100.0,
			space: 5,
		},
		shouldCheckOutput: true,
		want:              "ProgressTest[===== 100.0% =====]",
	},
	{
		name: "Should return labeless progressbar with 5 spaces each side",
		args: progressBarTestArgs{
			label: "",
			total: 100.0,
			space: 5,
		},
		shouldCheckOutput: true,
		want:              "[===== 100.0% =====]",
	},
	{
		name: "Should return labeless progressbar with 10 spaces each side",
		args: progressBarTestArgs{
			label: "",
			total: 100.0,
			space: 10,
		},
		shouldCheckOutput: true,
		want:              "[========== 100.0% ==========]",
	},
	{
		name: "Should ignore progressbar",
		args: progressBarTestArgs{
			label: "",
			total: 100.0,
			space: 10,
		},
		shouldCheckOutput: false,
		want:              "",
	},
}

// TestProgressBar tests the functions [ProgressBar()]
func TestProgressBar(t *testing.T) {
	for _, tt := range progressBarTests {
		t.Run(tt.name, func(t *testing.T) {
			var wg sync.WaitGroup
			var out bytes.Buffer

			wg.Add(1)
			progress := make(chan float64, 1)
			progressBar := NewProgressBar(tt.args.label, tt.args.space, tt.args.total, progress)
			if tt.shouldCheckOutput {
				progressBar.Writer = &out
			} else {
				// TODO ioutil will be deprecated on go v1.16, so ioutil.Discard should be changed to io.Discard
				progressBar.Writer = ioutil.Discard
			}
			go progressBar.Start(&wg)
			if tt.shouldCheckOutput {
				for i := 0; i < 101; i++ {
					progress <- float64(i)
				}
				progress <- float64(100)
			}
			wg.Wait()
			splittedOut := strings.Split(out.String(), "\r")
			require.Equal(t, tt.want, splittedOut[len(splittedOut)-1])
		})
	}
}

func TestFileAnalyzer(t *testing.T) {
	if err := test.ChangeCurrentDir("kics"); err != nil {
		t.Fatal(err)
	}

	tests := []struct {
		name    string
		arg     string
		want    string
		wantErr bool
	}{
		{
			name:    "file_analizer_json",
			arg:     "test/fixtures/config_test/kics.json",
			want:    "json",
			wantErr: false,
		},
		{
			name:    "file_analizer_json_no_extension",
			arg:     "test/fixtures/config_test/kics.config_json",
			want:    "json",
			wantErr: false,
		},
		{
			name:    "file_analizer_yaml",
			arg:     "test/fixtures/config_test/kics.yaml",
			want:    "yaml",
			wantErr: false,
		},
		{
			name:    "file_analizer_yaml_no_extension",
			arg:     "test/fixtures/config_test/kics.config_yaml",
			want:    "yaml",
			wantErr: false,
		},
		{
			name:    "file_analizer_hcl",
			arg:     "test/fixtures/config_test/kics.hcl",
			want:    "hcl",
			wantErr: false,
		},
		{
			name:    "file_analizer_hcl_no_extension",
			arg:     "test/fixtures/config_test/kics.config_hcl",
			want:    "hcl",
			wantErr: false,
		},
		{
			name:    "file_analizer_toml",
			arg:     "test/fixtures/config_test/kics.toml",
			want:    "toml",
			wantErr: false,
		},
		{
			name:    "file_analizer_toml_no_extension",
			arg:     "test/fixtures/config_test/kics.config_toml",
			want:    "toml",
			wantErr: false,
		},
		{
			name:    "file_analizer_js_incorrect",
			arg:     "test/fixtures/config_test/kics.config_js",
			want:    "",
			wantErr: true,
		},
		{
			name:    "file_analizer_js_no_extension_incorrect",
			arg:     "test/fixtures/config_test/kics.js",
			want:    "",
			wantErr: true,
		},
		{
			name:    "file_analizer_js_wrong_extension",
			arg:     "test/fixtures/config_test/kics_wrong.js",
			want:    "yaml",
			wantErr: false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := FileAnalyzer(tt.arg)
			if (err != nil) != tt.wantErr {
				t.Errorf("FileAnalyzer() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("FileAnalyzer() = %v, want %v", got, tt.want)
			}
		})
	}
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
				sev:     "HIGH",
			},
			want: "test_high_content",
		},
		{
			name: "test_medium",
			args: args{
				content: "test_medium_content",
				sev:     "MEDIUM",
			},
			want: "test_medium_content",
		},
		{
			name: "test_low",
			args: args{
				content: "test_low_content",
				sev:     "LOW",
			},
			want: "test_low_content",
		},
		{
			name: "test_info",
			args: args{
				content: "test_info_content",
				sev:     "INFO",
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

	printer := NewPrinter()
	color.Disable()
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := printer.PrintBySev(tt.args.content, tt.args.sev)
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("PrintBySev() = %v, want = %v", got, tt.want)
			}
		})
	}
}

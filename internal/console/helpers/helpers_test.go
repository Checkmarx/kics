package helpers

import (
	"bytes"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"reflect"
	"strings"
	"sync"
	"testing"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/test"
	"github.com/gookit/color"
	"github.com/stretchr/testify/require"
)

var printTests = []struct {
	caseTest       model.Summary
	expectedResult string
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
	},
}

var failedQueries = map[string]error{}

// TestPrintResult tests the functions [PrintResult()] and all the methods called by them
func TestPrintResult(t *testing.T) {
	color.Disable()
	for idx, testCase := range printTests {
		t.Run(fmt.Sprintf("Print test case %d", idx), func(t *testing.T) {
			out, err := test.CaptureOutput(func() error { return PrintResult(&testCase.caseTest, failedQueries, NewPrinter(true)) })
			require.NoError(t, err)
			require.Equal(t, testCase.expectedResult, out)
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
				progressBar.Writer = io.Discard
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

func TestHelpers_ValidateReportFormats(t *testing.T) {
	tests := []struct {
		name    string
		formats []string
		wantErr bool
	}{
		{
			name:    "test_validate_report_formats",
			formats: []string{"json", "html", "sarif"},
			wantErr: false,
		},
		{
			name:    "test_validate_report_unknown_format",
			formats: []string{"json", "html", "sarif", "unknown"},
			wantErr: true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			err := ValidateReportFormats(tt.formats)
			if (err != nil) != tt.wantErr {
				t.Errorf("ValidateReportFormats() = %v, wantErr = %v", err, tt.wantErr)
			}
		})
	}
}

func TestHelpers_GenerateReport(t *testing.T) {
	type args struct {
		path     string
		filename string
		body     interface{}
		formats  []string
	}
	tests := []struct {
		name    string
		args    args
		wantErr bool
		remove  []string
	}{
		{
			name: "test_generate_report",
			args: args{
				path:     ".",
				filename: "result",
				body:     "",
				formats:  []string{"json"},
			},
			wantErr: false,
			remove:  []string{"result.json"},
		},
		{
			name: "test_generate_report_error",
			args: args{
				path:     ".",
				filename: "result",
				body:     "",
				formats:  []string{"html"},
			},
			wantErr: true,
			remove:  []string{"result.html"},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			err := GenerateReport(tt.args.path, tt.args.filename, tt.args.body, tt.args.formats)
			if (err != nil) != tt.wantErr {
				t.Errorf("GenerateReport() = %v, wantErr = %v", err, tt.wantErr)
			}
			for _, file := range tt.remove {
				err := os.Remove(filepath.Join(tt.args.path, file))
				require.NoError(t, err)
			}
		})
	}
}

func TestHelpers_GetDefaultQueryPath(t *testing.T) {
	if err := test.ChangeCurrentDir("kics"); err != nil {
		t.Fatal(err)
	}

	cd, err := os.Getwd()
	require.NoError(t, err)

	tests := []struct {
		name        string
		queriesPath string
		want        string
		wantErr     bool
	}{
		{
			name:        "test_get_defaul_query_path",
			queriesPath: filepath.FromSlash("assets/queries"),
			want:        filepath.Join(cd, filepath.FromSlash("assets/queries")),
			wantErr:     false,
		},
		{
			name:        "test_get_defaul_query_path_error",
			queriesPath: filepath.FromSlash("error"),
			want:        "",
			wantErr:     true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := GetDefaultQueryPath(tt.queriesPath)
			if (err != nil) != tt.wantErr {
				t.Errorf("GetDefaultQueryPath() = %v, wantErr = %v", err, tt.wantErr)
			}
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("GetDefaultQueryPath() = %v, want = %v", got, tt.want)
			}
		})
	}
}

func TestHelpers_WordWrap(t *testing.T) {
	type args struct {
		s          string
		identation string
		limit      int
	}

	tests := []struct {
		name string
		args args
		want string
	}{
		{
			name: "test_word_wrap",
			args: args{
				s:          "testing",
				identation: "-",
				limit:      1,
			},
			want: "-testing\r\n",
		},
		{
			name: "test_word_wrap",
			args: args{
				s:          "",
				identation: "-",
				limit:      1,
			},
			want: "",
		},
		{
			name: "test_word_wrap",
			args: args{
				s:          "testing string word wrap",
				identation: "-",
				limit:      2,
			},
			want: "-testing string\r\n-word wrap\r\n",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := WordWrap(tt.args.s, tt.args.identation, tt.args.limit)
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("WordWrap =\n%v, want = \n%v", got, tt.want)
			}
		})
	}
}

func TestHelpers_ListReportFormats(t *testing.T) {
	formats := ListReportFormats()
	for _, format := range formats {
		_, ok := reportGenerators[format]
		require.True(t, ok)
	}
}

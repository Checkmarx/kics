package helpers

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
	"strings"
	"sync"
	"testing"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/test"
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
			"\tpositive.tf:25\n" +
			"\tpositive.tf:19\n\n" +
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
	for idx, testCase := range printTests {
		t.Run(fmt.Sprintf("Print test case %d", idx), func(t *testing.T) {
			out, err := test.CaptureOutput(func() error { return PrintResult(&testCase.caseTest, failedQueries) })
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
	name string
	args progressBarTestArgs
	want string
}{
	{
		name: "Labeled progressbar with 5 spaces each side",
		args: progressBarTestArgs{
			label: "ProgressTest",
			total: 100.0,
			space: 5,
		},
		want: "ProgressTest[===== 100.0% =====]",
	},
	{
		name: "Labeless progressbar with 5 spaces each side",
		args: progressBarTestArgs{
			label: "",
			total: 100.0,
			space: 5,
		},
		want: "[===== 100.0% =====]",
	},
	{
		name: "Labeless progressbar with 10 spaces each side",
		args: progressBarTestArgs{
			label: "",
			total: 100.0,
			space: 10,
		},
		want: "[========== 100.0% ==========]",
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
			progressBar.Writer = &out
			go progressBar.Start(&wg)
			for i := 0; i < 101; i++ {
				progress <- float64(i)
			}
			progress <- float64(100)
			wg.Wait()
			splittedOut := strings.Split(out.String(), "\r")
			require.Equal(t, tt.want, splittedOut[len(splittedOut)-1])
		})
	}
}

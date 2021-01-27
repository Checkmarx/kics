package console

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
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

// TestPrintResult tests the functions [printResult()] and all the methods called by them
func TestPrintResult(t *testing.T) {
	for idx, testCase := range printTests {
		t.Run(fmt.Sprintf("Print test case %d", idx), func(t *testing.T) {
			out, err := test.CaptureOutput(func() error { return printResult(&testCase.caseTest, failedQueries) })
			require.NoError(t, err)
			require.Equal(t, testCase.expectedResult, out)
		})
	}
}

// TestPrintToJSONFile tests the functions [printToJSONFile()] and all the methods called by them
func TestPrintToJSONFile(t *testing.T) {
	for idx, test := range jsonTests {
		t.Run(fmt.Sprintf("JSON File test case %d", idx), func(t *testing.T) {
			var err error
			err = printToJSONFile(test.caseTest.path, test.caseTest.summary)
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

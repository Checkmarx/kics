package report

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"testing"

	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/Checkmarx/kics/v2/test"
	"github.com/stretchr/testify/require"
)

type jsonCaseTest struct {
	summary  model.Summary
	path     string
	filename string
}

var jsonTests = []struct {
	caseTest       jsonCaseTest
	expectedResult model.Summary
}{
	{
		caseTest: jsonCaseTest{
			summary:  test.SummaryMock,
			path:     "./testdir",
			filename: "testout",
		},
		expectedResult: test.SummaryMock,
	},
	{
		caseTest: jsonCaseTest{
			summary:  test.SummaryMockCritical,
			path:     "./testdir",
			filename: "testout2",
		},
		expectedResult: test.SummaryMockCritical,
	},
	{
		caseTest: jsonCaseTest{
			summary:  test.SummaryMockCWE,
			path:     "./testdir",
			filename: "testout3",
		},
		expectedResult: test.SummaryMockCWE,
	},
}

// TestPrintJSONReport tests the functions [PrintJSONReport()] and all the methods called by them
func TestPrintJSONReport(t *testing.T) {
	for idx, test := range jsonTests {
		t.Run(fmt.Sprintf("JSON File test case %d", idx), func(t *testing.T) {
			test.expectedResult.Version = "development"
			var err error
			if err = os.MkdirAll(test.caseTest.path, os.ModePerm); err != nil {
				t.Fatal(err)
			}
			err = PrintJSONReport(test.caseTest.path, test.caseTest.filename, test.caseTest.summary)
			require.NoError(t, err)
			require.FileExists(t, filepath.Join(test.caseTest.path, test.caseTest.filename+".json"))
			var jsonResult []byte
			jsonResult, err = os.ReadFile(filepath.Join(test.caseTest.path, test.caseTest.filename+".json"))
			require.NoError(t, err)
			var resultSummary model.Summary
			err = json.Unmarshal(jsonResult, &resultSummary)
			require.NoError(t, err)
			if len(resultSummary.Queries) > 0 {
				resultSummary.Queries[0].Files[0].VulnLines = &[]model.CodeLine{}
				if len(resultSummary.Queries[0].Files) > 1 {
					resultSummary.Queries[0].Files[1].VulnLines = &[]model.CodeLine{}
				}
			}
			require.Equal(t, test.expectedResult, resultSummary)
			os.RemoveAll(test.caseTest.path)
		})
	}
}

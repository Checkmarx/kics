package report

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"testing"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/test"
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
}

// TestPrintJSONReport tests the functions [PrintJSONReport()] and all the methods called by them
func TestPrintJSONReport(t *testing.T) {
	for idx, test := range jsonTests {
		t.Run(fmt.Sprintf("JSON File test case %d", idx), func(t *testing.T) {
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
			require.Equal(t, test.expectedResult, resultSummary)
			os.RemoveAll(test.caseTest.path)
		})
	}
}

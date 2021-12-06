package report

import (
	"fmt"
	"os"
	"path/filepath"
	"testing"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/test"
	"github.com/stretchr/testify/require"
)

var junitTests = []struct {
	caseTest       jsonCaseTest
	expectedResult model.Summary
}{
	{
		caseTest: jsonCaseTest{
			summary:  test.SummaryMock,
			path:     "./testdir",
			filename: "test",
		},
		expectedResult: test.SummaryMock,
	},
}

// TestPrintJUnitReport tests the functions [PrintJUnitReport()] and all the methods called by them
func TestPrintJUnitReport(t *testing.T) {
	for idx, test := range junitTests {
		t.Run(fmt.Sprintf("JUnit Report File test case %d", idx), func(t *testing.T) {
			if err := os.MkdirAll(test.caseTest.path, os.ModePerm); err != nil {
				t.Fatal(err)
			}
			err := PrintJUnitReport(test.caseTest.path, test.caseTest.filename, test.caseTest.summary)
			require.NoError(t, err)
			require.FileExists(t, filepath.Join(test.caseTest.path, "junit-"+test.caseTest.filename+".xml"))
			os.RemoveAll(test.caseTest.path)
		})
	}
}

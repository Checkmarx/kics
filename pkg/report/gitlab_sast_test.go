package report

import (
	"fmt"
	"os"
	"path/filepath"
	"testing"

	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/Checkmarx/kics/v2/test"
	"github.com/stretchr/testify/require"
)

var gitlabSASTTests = []struct {
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
	{
		caseTest: jsonCaseTest{
			summary:  test.SummaryMockCritical,
			path:     "./testdir",
			filename: "test2",
		},
		expectedResult: test.SummaryMockCritical,
	},
	{
		caseTest: jsonCaseTest{
			summary:  test.SummaryMockCWE,
			path:     "./testdir",
			filename: "test3",
		},
		expectedResult: test.SummaryMockCWE,
	},
}

// TestPrintGitlabSASTReport tests the functions [PrintGitlabSASTReport()] and all the methods called by them
func TestPrintGitlabSASTReport(t *testing.T) {
	for idx, test := range gitlabSASTTests {
		t.Run(fmt.Sprintf("Gitlab SAST Report File test case %d", idx), func(t *testing.T) {
			if err := os.MkdirAll(test.caseTest.path, os.ModePerm); err != nil {
				t.Fatal(err)
			}
			err := PrintGitlabSASTReport(test.caseTest.path, test.caseTest.filename, test.caseTest.summary)
			require.NoError(t, err)
			require.FileExists(t, filepath.Join(test.caseTest.path, "gl-sast-"+test.caseTest.filename+".json"))
			os.RemoveAll(test.caseTest.path)
		})
	}
}

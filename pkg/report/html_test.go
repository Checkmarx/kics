package report

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"testing"

	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/Checkmarx/kics/v2/test"
	"github.com/stretchr/testify/require"
	"golang.org/x/net/html"
)

var htmlTests = []struct {
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

// TestPrintHTMLReport tests the functions [PrintHTMLReport()] and all the methods called by them
func TestPrintHTMLReport(t *testing.T) {
	for idx, test := range htmlTests {
		t.Run(fmt.Sprintf("HTML File test case %d", idx), func(t *testing.T) {
			if err := os.MkdirAll(test.caseTest.path, os.ModePerm); err != nil {
				t.Fatal(err)
			}
			err := PrintHTMLReport(test.caseTest.path, test.caseTest.filename, test.caseTest.summary)
			require.NoError(t, err)
			require.FileExists(t, filepath.Join(test.caseTest.path, test.caseTest.filename+".html"))
			htmlString, err := os.ReadFile(filepath.Join(test.caseTest.path, test.caseTest.filename+".html"))
			require.NoError(t, err)
			valid, err := html.Parse(strings.NewReader(string(htmlString)))
			require.NoError(t, err)
			require.NotNil(t, valid)
			os.RemoveAll(test.caseTest.path)
		})
	}
}

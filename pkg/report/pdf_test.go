package report

import (
	"fmt"
	"os"
	"testing"

	"github.com/Checkmarx/kics/v2/test"
)

var pdfTests = []reportTestCase{
	{
		caseTest: jsonCaseTest{
			summary:  test.SummaryMock,
			path:     "./testdir",
			filename: "testpdf",
		},
	},
	{
		caseTest: jsonCaseTest{
			summary:  test.SummaryMock,
			path:     "./testdir/newdir",
			filename: "testpdf2",
		},
	},
	{
		caseTest: jsonCaseTest{
			summary:  test.SummaryMockCWE,
			path:     "./testdir/newdir",
			filename: "testpdf3",
		},
	},
	{
		caseTest: jsonCaseTest{
			summary:  test.SummaryMockCritical,
			path:     "./testdir/newdir",
			filename: "testpdf4",
		},
	},
}

// TestPrintPdfReport tests the functions [PrintPdfReport()] and all the methods called by them
func TestPrintPdfReport(t *testing.T) {
	for i, test := range pdfTests {
		t.Run(fmt.Sprintf("PDF report test case %d", i), func(t *testing.T) {
			if err := os.MkdirAll(test.caseTest.path, os.ModePerm); err != nil {
				t.Fatal(err)
			}
			err := PrintPdfReport(test.caseTest.path, test.caseTest.filename, &test.caseTest.summary)
			checkFileExists(t, err, &test, "pdf")
			os.RemoveAll(test.caseTest.path)
		})
	}
}

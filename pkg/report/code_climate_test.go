package report

import (
	"os"
	"path/filepath"
	"testing"

	"github.com/Checkmarx/kics/v2/test"
	"github.com/stretchr/testify/require"
)

func TestPrintCodeClimateReport(t *testing.T) {
	tests := []struct {
		name     string
		caseTest jsonCaseTest
	}{
		{
			name: "print code climate report",
			caseTest: jsonCaseTest{
				summary:  test.SummaryMock,
				path:     filepath.Join(os.TempDir(), "testdir"),
				filename: "output",
			},
		},
		{
			name: "print code climate report critical",
			caseTest: jsonCaseTest{
				summary:  test.SummaryMockCritical,
				path:     filepath.Join(os.TempDir(), "testdir"),
				filename: "output2",
			},
		},
		{
			name: "print code climate report with cwe field complete",
			caseTest: jsonCaseTest{
				summary:  test.SummaryMockCWE,
				path:     filepath.Join(os.TempDir(), "testdir"),
				filename: "output3",
			},
		},
	}

	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			if err := os.MkdirAll(test.caseTest.path, os.ModePerm); err != nil {
				t.Fatal(err)
			}

			err := PrintCodeClimateReport(test.caseTest.path, test.caseTest.filename, test.caseTest.summary)
			require.NoError(t, err)

			require.FileExists(t, filepath.Join(test.caseTest.path, "codeclimate-"+test.caseTest.filename+".json"))
			os.RemoveAll(test.caseTest.path)
		})
	}
}

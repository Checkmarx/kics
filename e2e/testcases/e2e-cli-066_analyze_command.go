// Package testcases provides end-to-end (E2E) testing functionality for the application.
package testcases

// E2E-CLI-066 - KICS analyze
// should finish successfully and return exit code 0
func init() { //nolint
	testSample := TestCase{
		Name: "should perform a valid analyze [E2E-CLI-066]",
		Args: args{
			Args: []cmdArgs{
				[]string{"analyze",
					"--analyze-path", "/path/e2e/fixtures/samples/swagger",
					"--analyze-results", "/path/e2e/output/E2E_CLI_066_ANALYZE_RESULTS.json"},
				[]string{"analyze",
					"--analyze-path", "/path/e2e/fixtures/samples/positive.yaml",
					"--analyze-results", "/path/e2e/output/E2E_CLI_066_ANALYZE_RESULTS_2.json"},
			},
			ExpectedAnalyzerResults: []ResultsValidation{
				{
					ResultsFile:    "E2E_CLI_066_ANALYZE_RESULTS",
					ResultsFormats: []string{"json"},
				},
				{
					ResultsFile:    "E2E_CLI_066_ANALYZE_RESULTS_2",
					ResultsFormats: []string{"json"},
				},
			},
		},
		WantStatus: []int{0, 0},
	}
	Tests = append(Tests, testSample)
}

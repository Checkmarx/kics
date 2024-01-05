package testcases

// E2E-CLI-077 - KICS  scan
// should perform a scan saving the reports in sarif format, completing the cwe field when it has values
func init() { //nolint
	testSample := TestCase{
		Name: "should perform a scan saving the reports in sarif format, completing the cwe field when it has values [E2E-CLI-077]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_077_RESULT",
					"-p", "\"/path/test/fixtures/test_sarif_cwe_report\"",
					"--report-formats", "sarif",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "E2E_CLI_077_RESULT",
					ResultsFormats: []string{"sarif"},
				},
			},
		},
		WantStatus: []int{00},
	}

	Tests = append(Tests, testSample)
}

package testcases

// E2E-CLI-080 - KICS  scan
// should perform a scan saving the reports in sarif format, showing no cwe field on results
func init() { //nolint
	testSample := TestCase{
		Name: "should perform a scan saving the reports in sarif format, showing no cwe field on results [E2E-CLI-080]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_080_RESULT",
					"-p", "\"/path/test/fixtures/test_sarif_cwe_report/script_block_injection/test\"",
					"-q", "\"/path/test/fixtures/test_sarif_cwe_report/script_block_injection/query\"",
					"--report-formats", "sarif",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "E2E_CLI_080_RESULT",
					ResultsFormats: []string{"sarif"},
				},
			},
		},
		WantStatus: []int{50},
	}

	Tests = append(Tests, testSample)
}

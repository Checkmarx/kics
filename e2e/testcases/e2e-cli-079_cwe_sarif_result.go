package testcases

// E2E-CLI-079 - KICS  scan
// should perform a scan saving the reports in sarif format, showing the cwe on results
func init() { //nolint
	testSample := TestCase{
		Name: "should perform a scan saving the reports in sarif format, showing the cwe on results [E2E-CLI-079]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_079_RESULT",
					"-p", "\"/path/test/fixtures/test_sarif_cwe_report/run_block_injection/test\"",
					"-q", "\"/path/test/fixtures/test_sarif_cwe_report/run_block_injection/query\"",
					"--report-formats", "sarif",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "E2E_CLI_079_RESULT",
					ResultsFormats: []string{"sarif"},
				},
			},
		},
		WantStatus: []int{50},
	}

	Tests = append(Tests, testSample)
}

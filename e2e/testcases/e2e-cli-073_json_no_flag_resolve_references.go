package testcases

// E2E-CLI-073 - KICS  scan and ignore references
// should perform the scan successfully and return exit code 0
// no results expected
func init() { //nolint
	testSample := TestCase{
		Name: "should perform a valid scan and not resolve references [E2E-CLI-073]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_073_RESULT",
					"-p", "\"/path/test/fixtures/resolve_references_json\"",
					"-i", "750b40be-4bac-4f59-bdc4-1ca0e6c3450e",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "E2E_CLI_073_RESULT",
					ResultsFormats: []string{"json"},
				},
			},
		},
		WantStatus: []int{0},
	}

	Tests = append(Tests, testSample)
}

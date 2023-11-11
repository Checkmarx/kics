package testcases

// E2E-CLI-074 - KICS  scan and ignore references
// should perform the scan successfully and return exit code 20
func init() { //nolint
	testSample := TestCase{
		Name: "should perform a valid scan and resolve references [E2E-CLI-074]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_074_RESULT",
					"-p", "\"/path/test/fixtures/resolve_references_json\"",
					"-i", "750b40be-4bac-4f59-bdc4-1ca0e6c3450e",
					"--enable-openapi-refs",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "E2E_CLI_074_RESULT",
					ResultsFormats: []string{"json"},
				},
			},
		},
		WantStatus: []int{20},
	}

	Tests = append(Tests, testSample)
}

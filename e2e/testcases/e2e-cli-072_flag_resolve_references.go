package testcases

// E2E-CLI-072 - KICS  scan and ignore references
// should perform the scan successfully and return exit code 40,20
func init() { //nolint
	testSample := TestCase{
		Name: "should perform a valid scan and resolve references [E2E-CLI-072]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_072_RESULT",
					"-p", "\"/path/test/fixtures/resolve_references\"",
					"-i", "6c35d2c6-09f2-4e5c-a094-e0e91327071d,962fa01e-b791-4dcc-b04a-4a3e7389be5e",
					"--enable-openapi-refs",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "E2E_CLI_072_RESULT",
					ResultsFormats: []string{"json"},
				},
			},
		},
		WantStatus: []int{30},
	}

	Tests = append(Tests, testSample)
}

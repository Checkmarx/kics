// Package testcases provides end-to-end (E2E) testing functionality for the application.
package testcases

// E2E-CLI-068 - KICS  scan but recover from corrupted dockerfile
// should perform the scan successfully and return exit code 50
func init() { //nolint
	testSample := TestCase{
		Name: "should perform a valid scan and recover from a corrupted dockerfile [E2E-CLI-068]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output", "--output-name", "E2E_CLI_068_RESULT",
					"-p", "/path/test/fixtures/dockerfile/corrupted_dockerfile",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "E2E_CLI_068_RESULT",
					ResultsFormats: []string{"json"},
				},
			},
		},
		WantStatus: []int{50},
	}

	Tests = append(Tests, testSample)
}

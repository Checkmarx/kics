// Package testcases provides end-to-end (E2E) testing functionality for the application.
package testcases

// E2E-CLI-104 - KICS scan should parse and evaluate terraform locals and find vulnerabilities
// should perform the scan successfully, find issues, and return exit code 50
func init() { //nolint
	testSample := TestCase{
		Name: "should perform a valid scan, evaluate terraform locals, and find vulnerabilities [E2E-CLI-104]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_104_RESULT",
					"-p", "\"/path/e2e/fixtures/samples/terraform-locals\"",
					"--payload-path", "/path/e2e/output/E2E_CLI_104_PAYLOAD.json"},
			},
			ExpectedPayload: []string{
				"E2E_CLI_104_PAYLOAD.json",
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile: "E2E_CLI_104_RESULT",
				},
			},
		},
		WantStatus: []int{50},
	}

	Tests = append(Tests, testSample)
}

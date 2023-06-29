// Package testcases provides end-to-end (E2E) testing functionality for the application.
package testcases

// E2E-CLI-062 - KICS  scan and get the variables using a variables path as a comment
// should perform the scan successfully and return exit code 0
func init() { //nolint
	testSample := TestCase{
		Name: "should perform a valid scan and get the variables using a variables path as a comment [E2E-CLI-062]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-p", "\"/path/e2e/fixtures/samples/terraform-vars-path/tfFiles\"",
					"--silent", "--payload-path", "/path/e2e/output/E2E_CLI_062_PAYLOAD.json"},
			},
			ExpectedPayload: []string{
				"E2E_CLI_062_PAYLOAD.json",
			},
		},
		WantStatus: []int{0},
	}

	Tests = append(Tests, testSample)
}

// Package testcases provides end-to-end (E2E) testing functionality for the application.
package testcases

// E2E-CLI-071 - KICS scan while evaluating the terraform functions with unknown type
// should perform the scan successfully and return exit code 40
func init() { //nolint
	testSample := TestCase{
		Name: "should perform a valid scan while evaluating the terraform functions with unknown type [E2E-CLI-071]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-p", "\"/path/e2e/fixtures/samples/tf-eval-func-unknown-type/main.tf\"",
					"--silent", "--payload-path", "/path/e2e/output/E2E_CLI_071_PAYLOAD.json"},
			},
			ExpectedPayload: []string{
				"E2E_CLI_071_PAYLOAD.json",
			},
		},
		WantStatus: []int{40},
	}

	Tests = append(Tests, testSample)
}

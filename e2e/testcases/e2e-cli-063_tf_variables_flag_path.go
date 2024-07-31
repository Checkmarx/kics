// Package testcases provides end-to-end (E2E) testing functionality for the application.
package testcases

// E2E-CLI-063 - KICS  scan and get the variables using a variables path as a flag
// should perform the scan successfully and return exit code 0
func init() { //nolint
	testSample := TestCase{
		Name: "should perform a valid scan and get the variables using a variables path as a flag [E2E-CLI-063]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-p", "\"/path/e2e/fixtures/samples/terraform-vars-path/tfFiles\"",
					"--silent", "--payload-path", "/path/e2e/output/E2E_CLI_063_PAYLOAD.json",
					"--terraform-vars-path", "/path/e2e/fixtures/samples/terraform-vars-path/terraform-vars.tfvars"},
			},
			ExpectedPayload: []string{
				"E2E_CLI_063_PAYLOAD.json",
			},
		},
		WantStatus: []int{0},
	}

	Tests = append(Tests, testSample)
}

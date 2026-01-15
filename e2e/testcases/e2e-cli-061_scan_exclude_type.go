// Package testcases provides end-to-end (E2E) testing functionality for the application.
package testcases

// E2E-CLI-061 - KICS  scan with a valid case insensitive --exclude-type flag
// should perform the scan successfully and return exit code 50
func init() { //nolint
	testSample := TestCase{
		Name: "should perform a valid scan with --exclude-type flag [E2E-CLI-061]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-p", "\"/path/e2e/fixtures/samples/positive.dockerfile\",\"/path/e2e/fixtures/samples/terraform.tf\"",
					"--silent", "--payload-path", "/path/e2e/output/E2E_CLI_061_PAYLOAD.json", "--exclude-type",
					"TeRRafOrm"},
			},
			ExpectedPayload: []string{
				"E2E_CLI_061_PAYLOAD.json",
			},
		},
		WantStatus: []int{50},
	}

	Tests = append(Tests, testSample)
}

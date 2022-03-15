package testcases

// E2E-CLI-047 - Kics scan command with --payload-lines
// should display additional information lines in the payload file.
func init() { //nolint
	testSample := TestCase{
		Name: "should display line references in the payload file [E2E-CLI-047]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "--silent", "-p", "/path/e2e/fixtures/samples/terraform.tf",
					"--payload-path", "/path/e2e/output/E2E_CLI_047_PAYLOAD.json", "--payload-lines"},
			},
			ExpectedPayload: []string{
				"E2E_CLI_047_PAYLOAD.json",
			},
		},
		WantStatus: []int{50},
	}

	Tests = append(Tests, testSample)
}

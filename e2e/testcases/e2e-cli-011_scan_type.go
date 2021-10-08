package testcases

// E2E-CLI-011 - KICS  scan with a valid case insensitive --type flag
// should perform the scan successfully and return exit code 50
func init() { //nolint
	testSample := TestCase{
		Name: "should perform a valid scan with -t flag [E2E-CLI-011]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-q", "../assets/queries", "-p", "fixtures/samples/terraform.tf",
					"-t", "TeRraFOrM", "--silent", "--payload-path", "output/E2E_CLI_011_PAYLOAD.json"},
			},
			ExpectedPayload: []string{
				"E2E_CLI_011_PAYLOAD.json",
			},
		},
		WantStatus: []int{50},
	}

	Tests = append(Tests, testSample)
}

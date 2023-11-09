package testcases

// E2E-CLI-076 - KICS  scan and ignore references
// should perform the scan successfully and return exit code 50
// same test as 75 but without flag, we will expect the same file that test 75 expect
func init() { //nolint
	testSample := TestCase{
		Name: "should display line references in the payload file [E2E-CLI-075]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "--silent", "-p", "/path/test/fixtures/resolve_references_no_change/vpc.yml",
					"--payload-path", "/path/e2e/output/E2E_CLI_076_PAYLOAD.json", "--payload-lines"},
			},
			ExpectedPayload: []string{
				"E2E_CLI_075_PAYLOAD.json",
			},
		},
		WantStatus: []int{50},
	}

	Tests = append(Tests, testSample)
}

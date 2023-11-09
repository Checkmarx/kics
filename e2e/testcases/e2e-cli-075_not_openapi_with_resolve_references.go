package testcases

// E2E-CLI-075 - KICS  scan and not ignore references
// should perform the scan successfully and return exit code 50
// same test as 76 but with flag
func init() { //nolint
	testSample := TestCase{
		Name: "should display line references in the payload file [E2E-CLI-075]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "--silent", "-p", "/path/test/fixtures/resolve_references_no_change/vpc.yml",
					"--payload-path", "/path/e2e/output/E2E_CLI_075_PAYLOAD.json", "--payload-lines", "--resolve-references"},
			},
			ExpectedPayload: []string{
				"E2E_CLI_075_PAYLOAD.json",
			},
		},
		WantStatus: []int{50},
	}

	Tests = append(Tests, testSample)
}

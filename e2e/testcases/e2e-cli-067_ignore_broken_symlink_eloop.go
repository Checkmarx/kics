// Package testcases provides end-to-end (E2E) testing functionality for the application.
package testcases

// E2E-CLI-067 - KICS  scan but ignore broken symlinks and symlinks that create endless loops
// should perform the scan successfully and return exit code 0
func init() { //nolint
	testSample := TestCase{
		Name: "should perform a valid scan but ignore broken symlinks and symlinks that create endless loops [E2E-CLI-067]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-p", "\"/path/test/fixtures/link_test/broken_symlink\"", "\"/path/test/fixtures/link_test/eloop_link\"",
					"--silent", "--payload-path", "/path/e2e/output/E2E_CLI_067_PAYLOAD.json"},
			},
			ExpectedPayload: []string{
				"E2E_CLI_067_PAYLOAD.json",
			},
		},
		WantStatus: []int{0},
	}

	Tests = append(Tests, testSample)
}

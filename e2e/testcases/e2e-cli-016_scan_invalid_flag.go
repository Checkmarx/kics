package testcases

// E2E-CLI-016 - KICS has an invalid flag or invalid command
// an error message and return exit code 1
func init() { //nolint
	testSample := TestCase{
		Name: "should throw error messages for kics' flags [E2E-CLI-016]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "--invalid-flag"},
				[]string{"--invalid-flag"},
				[]string{"invalid"},
				[]string{"-i"},
			},
			ExpectedOut: []string{
				"E2E_CLI_016_INVALID_SCAN_FLAG",
				"E2E_CLI_016_INVALID_FLAG",
				"E2E_CLI_016_INVALID_COMMAND",
				"E2E_CLI_016_INVALID_SHOTHAND",
			},
		},
		WantStatus: []int{126, 126, 126, 126},
	}

	Tests = append(Tests, testSample)
}

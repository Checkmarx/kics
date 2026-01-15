package testcases

// E2E-CLI-001 - KICS command should display a help text in the CLI when provided with the
// --help flag and it should describe the available commands plus the global flags
func init() { //nolint
	testSample := TestCase{
		Name: "should display the kics help text [E2E-CLI-001]",
		Args: args{
			Args: []cmdArgs{
				[]string{"--help"},
			},
			ExpectedOut: []string{"E2E_CLI_001"},
		},
		WantStatus: []int{0},
	}

	Tests = append(Tests, testSample)
}

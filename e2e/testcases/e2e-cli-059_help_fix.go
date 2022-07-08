package testcases

// E2E-CLI-059 - KICS fix command should display a help text in the CLI when provided with the
// --help flag and it should describe the options related with fix plus the global options
func init() { //nolint
	testSample := TestCase{
		Name: "should display the kics fix help text [E2E-CLI-059]",
		Args: args{
			Args: []cmdArgs{
				[]string{"fix", "--help"},
			},
			ExpectedOut: []string{"E2E_CLI_059"},
		},
		WantStatus: []int{0},
	}

	Tests = append(Tests, testSample)
}

package testcases

// E2E-CLI-059 - KICS remediate command should display a help text in the CLI when provided with the
// --help flag and it should describe the options related with remediate plus the global options
func init() { //nolint
	testSample := TestCase{
		Name: "should display the kics remediate help text [E2E-CLI-059]",
		Args: args{
			Args: []cmdArgs{
				[]string{"remediate", "--help"},
			},
			ExpectedOut: []string{"E2E_CLI_059"},
		},
		WantStatus: []int{0},
	}

	Tests = append(Tests, testSample)
}

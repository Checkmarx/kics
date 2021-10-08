package testcases

// E2E-CLI-002 - KICS scan command should display a help text in the CLI when provided with the
// --help flag and it should describe the options related with scan plus the global options
func init() { //nolint
	testSample := TestCase{
		Name: "should display the kics scan help text [E2E-CLI-002]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "--help"},
			},
			ExpectedOut: []string{"E2E_CLI_002"},
		},
		WantStatus: []int{0},
	}

	Tests = append(Tests, testSample)
}

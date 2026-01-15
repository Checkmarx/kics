package testcases

// E2E-CLI-060 - KICS remediate command has a mandatory flag --results. The CLI should exhibit
// an error message and return exit code 126
func init() { //nolint
	testSample := TestCase{
		Name: "should display an error regarding missing --results flag [E2E-CLI-060]",
		Args: args{
			Args: []cmdArgs{
				[]string{"remediate"},
			},
			ExpectedOut: []string{"E2E_CLI_060"},
		},
		WantStatus: []int{126},
	}

	Tests = append(Tests, testSample)
}

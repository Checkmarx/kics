package testcases

// E2E-CLI-003 - KICS scan command had a mandatory flag -p the CLI should exhibit
// an error message and return exit code 1

func init() { //nolint
	testSample := TestCase{
		Name: "should display an error regarding missing -p flag [E2E-CLI-003]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan"},
			},
			ExpectedOut: []string{"E2E_CLI_003"},
		},
		WantStatus: []int{126},
	}

	Tests = append(Tests, testSample)
}

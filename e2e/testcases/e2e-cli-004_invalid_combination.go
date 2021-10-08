package testcases

// E2E-CLI-004 - KICS has an invalid flag combination
// an error message and return exit code 1

func init() { //nolint
	testSample := TestCase{
		Name: "should display an error of invalid flag combination [E2E-CLI-004]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "--ci", "--verbose"},
				[]string{"--ci", "scan", "--verbose"},
			},
			ExpectedOut: []string{
				"E2E_CLI_004",
				"E2E_CLI_004",
			},
		},
		WantStatus: []int{126, 126},
	}

	Tests = append(Tests, testSample)
}

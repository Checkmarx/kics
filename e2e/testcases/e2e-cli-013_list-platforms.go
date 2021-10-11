package testcases

// E2E-CLI-013 - KICS root command list-platforms
// should return all the supported platforms in the CLI
func init() { //nolint
	testSample := TestCase{
		Name: "should list all supported platforms [E2E-CLI-013]",
		Args: args{
			Args: []cmdArgs{
				[]string{"list-platforms"},
			},
			ExpectedOut: []string{
				"E2E_CLI_013",
			},
		},
		WantStatus: []int{0},
	}

	Tests = append(Tests, testSample)
}

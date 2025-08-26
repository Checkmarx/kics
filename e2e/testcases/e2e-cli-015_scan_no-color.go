package testcases

// E2E-CLI-015 KICS scan with --no-color flag
// should disable the colored outputs of kics in the CLI
func init() { //nolint
	testSample := TestCase{
		Name: "should disable colored output in the CLI [E2E-CLI-015]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "--no-color", "-p", "/path/e2e/fixtures/samples/positive.dockerfile"},
			},
			ExpectedOut: []string{
				"E2E_CLI_015",
			},
		},
		WantStatus: []int{50},
	}

	Tests = append(Tests, testSample)
}

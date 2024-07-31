package testcases

// E2E-CLI-029 - KICS scan command with --config flag
// should load a config file that provides commands and arguments to kics.
func init() { //nolint
	testSample := TestCase{
		Name: "should load a config file [E2E-CLI-029]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "--config", "/path/e2e/fixtures/samples/configs/config.json", "--type", "cloudformation"},

				[]string{"scan", "--config", "/path/e2e/fixtures/samples/configs/config.json"},

				[]string{"scan", "--config", "/path/e2e/fixtures/samples/configs/config.json", "--silent"},
			},
		},
		WantStatus: []int{50, 0, 126},
	}

	Tests = append(Tests, testSample)
}

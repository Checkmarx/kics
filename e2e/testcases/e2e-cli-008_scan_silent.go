package testcases

// E2E-CLI-008 - KICS  scan with --silent global flag
// should hide all the output text in the CLI (empty output)

func init() { //nolint
	testSample := TestCase{
		Name: "should hide all output text in CLI [E2E-CLI-008]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "--silent", "-p", "/path/e2e/fixtures/samples/positive.yaml"},
			},
			ExpectedOut: []string{"E2E_CLI_008"},
		},
		WantStatus: []int{50},
	}

	Tests = append(Tests, testSample)
}

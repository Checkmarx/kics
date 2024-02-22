package testcases

// E2E-CLI-082 - KICS  scan
// should check if output path is invalid
func init() { //nolint
	testSample := TestCase{
		Name: "should check if output path is invalid [E2E-CLI-082]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output?",
					"--output-name", "E2E_CLI_082_RESULT",
					"-p", "\"/path/test/fixtures/test_output_path\"",
				},
			},
			ExpectedOut: []string{
				"E2E_CLI_082_RESULT",
			},
		},
		WantStatus: []int{126},
	}

	Tests = append(Tests, testSample)
}

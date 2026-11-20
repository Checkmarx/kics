package testcases

// E2E-CLI-084 - KICS  scan
// should perform a scan and return zero results ignoring the block
func init() { //nolint
	testSample := TestCase{
		Name: "should perform a scan and return zero results ignoring the block [E2E-CLI-084]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_084_RESULT",
					"-p", "\"/path/test/fixtures/helm_ignore_block\"",
					"-i", "7c81d34c-8e5a-402b-9798-9f442630e678",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "E2E_CLI_084_RESULT",
					ResultsFormats: []string{"json"},
				},
			},
		},
		WantStatus: []int{0},
	}

	Tests = append(Tests, testSample)
}

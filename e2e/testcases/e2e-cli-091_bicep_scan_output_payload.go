package testcases

// E2E-CLI-091 - Kics scan command with -o and -d flags on bicep files
// should perform the scan successfully, evaluating the result and payload files
func init() { //nolint
	testSample := TestCase{
		Name: "should perform a scan on bicep files and create a result and payload file [E2E-CLI-091]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_091_RESULT",
					"-p", "\"/path/test/fixtures/bicep_test/test\"",
					"-d", "/path/e2e/output/E2E_CLI_091_PAYLOAD.json",
					"--disable-secrets",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "E2E_CLI_091_RESULT",
					ResultsFormats: []string{"json"},
				},
			},
			ExpectedPayload: []string{
				"E2E_CLI_091_PAYLOAD.json",
			},
		},
		WantStatus: []int{20},
	}

	Tests = append(Tests, testSample)
}

package testcases

// E2E-CLI-106 - KICS  scan
// should perform the scan successfully detect all valid dockerfile documents and return result 50
func init() { //nolint
	testSample := TestCase{
		Name: "should perform a valid scan with all dockerfile documents parsed [E2E-CLI-106]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_106_RESULT",
					"-p", "/path/test/fixtures/dockerfile",
					"-p", "/path/test/fixtures/negative_dockerfile",
					"--payload-path", "/path/e2e/output/E2E_CLI_106_PAYLOAD.json",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "E2E_CLI_106_RESULT",
					ResultsFormats: []string{"json"},
				},
			},
			ExpectedPayload: []string{
				"E2E_CLI_106_PAYLOAD.json",
			},
		},
		WantStatus: []int{50},
	}

	Tests = append(Tests, testSample)
}

package testcases

// E2E-CLI-107 - KICS  scan
// should perform the scan successfully detecting all dockerfile vulnerabilities on sample with 2 "FROM"
// statements on a single image
func init() { //nolint
	testSample := TestCase{
		Name: "should perform a valid scan on dockerfile multistage sample [E2E-CLI-107]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_107_RESULT",
					"-p", "/path/test/fixtures/dockerfile/Dockerfile-multistage",
					"--payload-path", "/path/e2e/output/E2E_CLI_107_PAYLOAD.json",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "E2E_CLI_107_RESULT",
					ResultsFormats: []string{"json"},
				},
			},
			ExpectedPayload: []string{
				"E2E_CLI_107_PAYLOAD.json",
			},
		},
		WantStatus: []int{50},
	}

	Tests = append(Tests, testSample)
}

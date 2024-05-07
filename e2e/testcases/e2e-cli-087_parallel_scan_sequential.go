package testcases

// E2E-CLI-087 - KICS  scan
// should perform a scan, finishing successfully and return exit code 0
func init() { //nolint
	testSample := TestCase{
		Name: "should perform a scan and finish successfully [E2E-CLI-087]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_087_RESULT",
					"-p", "\"/path/e2e/fixtures/samples/terraform.tf\"",
					"--parallel", "1",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "E2E_CLI_087_RESULT",
					ResultsFormats: []string{"json"},
				},
			},
		},
		WantStatus: []int{50},
	}

	Tests = append(Tests, testSample)
}

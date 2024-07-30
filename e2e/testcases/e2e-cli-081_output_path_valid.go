package testcases

// E2E-CLI-081 - KICS  scan
// should check if output path is valid
func init() { //nolint
	testSample := TestCase{
		Name: "should check if output path is valid [E2E-CLI-081]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_081_RESULT",
					"-p", "\"/path/test/fixtures/test_output_path\"",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "E2E_CLI_081_RESULT",
					ResultsFormats: []string{"json"},
				},
			},
		},
		WantStatus: []int{40},
	}

	Tests = append(Tests, testSample)
}

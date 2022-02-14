package testcases

// E2E-CLI-032 - KICS scan command with --output-path flag
// should set the output path and check the results.json report format
func init() { //nolint
	testSample := TestCase{
		Name: "should set the results output name [E2E-CLI-032]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "output", "--output-name", "E2E_CLI_032_RESULT",
					"-q", "../assets/queries", "-p", "fixtures/samples/positive.yaml",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "E2E_CLI_032_RESULT",
					ResultsFormats: []string{"json"},
				},
			},
		},
		WantStatus: []int{50},
	}

	Tests = append(Tests, testSample)
}

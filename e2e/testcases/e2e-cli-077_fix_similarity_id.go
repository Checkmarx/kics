package testcases

// E2E-CLI-077 - KICS  scan
// should perform a scan, present two results, without the same similarity id
func init() { //nolint
	testSample := TestCase{
		Name: "should perform a scan, present two results, without the same similarity id [E2E-CLI-077]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_077_RESULT",
					"-p", "\"/path/test/fixtures/similarity_id\"",
					"-i", "488847ff-6031-487c-bf42-98fd6ac5c9a0",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "E2E_CLI_077_RESULT",
					ResultsFormats: []string{"json"},
				},
			},
		},
		WantStatus: []int{40},
	}

	Tests = append(Tests, testSample)
}

package testcases

// E2E-CLI-078 - KICS  scan
// should perform a scan and return three different similarity ids on the results
func init() { //nolint
	testSample := TestCase{
		Name: "should perform a scan and return three different similarity ids on the results [E2E-CLI-078]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_078_RESULT",
					"-p", "\"/path/test/fixtures/minified_files_similarity_id\"",
					"-i", "00b78adf-b83f-419c-8ed8-c6018441dd3a",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "E2E_CLI_078_RESULT",
					ResultsFormats: []string{"json"},
				},
			},
		},
		WantStatus: []int{40},
	}

	Tests = append(Tests, testSample)
}

package testcases

// E2E-CLI-070 - KICS  scan and not ignore experimental queries
// should perform the scan successfully and return exit code 40 and 50
func init() { //nolint
	samplePath := "/path/test/fixtures/experimental_test/sample"
	queriesPath := "/path/test/fixtures/experimental_test/queries"

	paths := []string{samplePath, queriesPath}

	testSample := TestCase{
		Name: "should perform a valid scan and not ignore the experimental queries [E2E-CLI-070]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output", "--output-name", "E2E_CLI_070_RESULT",
					"-p", "\"" + paths[0] + "\"", "-q", "\"" + paths[1] + "\"",
					"--experimental-queries",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "E2E_CLI_070_RESULT",
					ResultsFormats: []string{"json"},
				},
			},
		},
		WantStatus: []int{50},
	}

	Tests = append(Tests, testSample)
}

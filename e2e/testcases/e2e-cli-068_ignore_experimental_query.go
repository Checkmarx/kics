package testcases

// E2E-CLI-068 - KICS  scan and ignore experimental queries
// should perform the scan successfully and return exit code 40
const (
	samplePath  = "/path/test/fixtures/experimental_test/sample"
	queriesPath = "/path/test/fixtures/experimental_test/queries"
)

func init() { //nolint
	paths := []string{samplePath, queriesPath}

	testSample := TestCase{
		Name: "should perform a valid scan and ignore the experimental queries [E2E-CLI-068]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output", "--output-name", "E2E_CLI_068_RESULT",
					"-p", "\"" + paths[0] + "\"", "-q", "\"" + paths[1] + "\"",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "E2E_CLI_068_RESULT",
					ResultsFormats: []string{"json"},
				},
			},
		},
		WantStatus: []int{40},
	}

	Tests = append(Tests, testSample)
}

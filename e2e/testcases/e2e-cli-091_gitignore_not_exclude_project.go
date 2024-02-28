package testcases

// E2E-CLI-091 - KICS  scan
// should perform a scan and not ignore the entire project
func init() { //nolint
	testSample := TestCase{
		Name: "should perform a scan and not ignore the entire project [E2E-CLI-091]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_091_RESULT",
					"-p", "\"/path/e2e/fixtures/samples/tmp-gitignore/project\"",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "E2E_CLI_091_RESULT",
					ResultsFormats: []string{"json"},
				},
			},
		},
		WantStatus: []int{50},
	}

	Tests = append(Tests, testSample)
}

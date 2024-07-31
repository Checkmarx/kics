package testcases

// E2E-CLI-041 - Kics scan command with -p targeting remote path (git)
// should download and scan the provided path.
func init() { //nolint
	testSample := TestCase{
		Name: "should download and scan the provided git path [E2E-CLI-041]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "--output-path", "/path/e2e/output", "--output-name", "E2E_CLI_041_RESULT",
					"--report-formats", "json,sarif,glsast",
					"-p", "git::https://github.com/dockersamples/example-voting-app"},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "E2E_CLI_041_RESULT",
					ResultsFormats: []string{"json", "sarif", "glsast"},
				},
			},
		},
		WantStatus: []int{50},
	}

	Tests = append(Tests, testSample)
}

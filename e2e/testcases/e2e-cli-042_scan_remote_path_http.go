package testcases

// E2E-CLI-042 - Kics scan command with -p targeting remote path (http/https)
// should download and scan the provided path/file.
func init() { //nolint
	testSample := TestCase{
		Name: "should download and scan the provided http path/file [E2E-CLI-042]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "--output-path", "/path/e2e/output", "--output-name", "E2E_CLI_042_RESULT",
					"--report-formats", "json,sarif,glsast",
					"-p", "https://raw.githubusercontent.com/dockersamples/example-voting-app/main/docker-compose.yml"},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "E2E_CLI_042_RESULT",
					ResultsFormats: []string{"json", "sarif", "glsast"},
				},
			},
		},
		WantStatus: []int{50},
	}

	Tests = append(Tests, testSample)
}

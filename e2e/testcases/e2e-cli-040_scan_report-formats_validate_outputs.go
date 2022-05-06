package testcases

// E2E-CLI-040 - Kics  scan command with --report-formats and --output-path flags
// should export the results based on the formats provided by this flag.
func init() { //nolint
	testSample := TestCase{
		Name: "should export the results based on report formats [E2E-CLI-040]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "--output-path", "/path/e2e/output", "--output-name", "E2E_CLI_040_RESULT",
					"--report-formats", "json,sarif,glsast,html,sonarqube",
					"-p", "/path/e2e/fixtures/samples/positive.yaml"},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "E2E_CLI_040_RESULT",
					ResultsFormats: []string{"json", "sarif", "glsast", "html", "sonarqube"},
				},
			},
		},
		WantStatus: []int{50},
	}

	Tests = append(Tests, testSample)
}

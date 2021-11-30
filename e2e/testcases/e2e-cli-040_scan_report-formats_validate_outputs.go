package testcases

// E2E-CLI-040 - Kics  scan command with --report-formats and --output-path flags
// should export the results based on the formats provided by this flag.
func init() { //nolint
	testSample := TestCase{
		Name: "should export the results based on report formats [E2E-CLI-040]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "--output-path", "output", "--output-name", "E2E_CLI_040_RESULT",
					"--report-formats", "json,sarif,glsast,html,sonarqube",
					"-q", "../assets/queries", "-p", "fixtures/samples/positive.yaml"},
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

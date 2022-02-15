package testcases

// E2E-CLI-031 - Kics  scan command with --report-formats and --output-path flags
// should export the results based on the formats provided by this flag.
func init() { //nolint
	testSample := TestCase{
		Name: "should export the results based on different formats [E2E-CLI-031]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "--output-path", "output", "--output-name", "E2E_CLI_031_RESULT",
					"--report-formats", "json,SARIF,glsast,Html,SonarQUBE,Junit,cyclonedx,asff",
					"-q", "../assets/queries", "-p", "fixtures/samples/positive.yaml"},

				[]string{"scan", "--output-path", "output", "--output-name", "E2E_CLI_031_RESULT_CIS",
					"--report-formats", "json,JUnit", "--include-queries", "275a3217-ca37-40c1-a6cf-bb57d245ab32",
					"-q", "../assets/queries", "-p", "fixtures/samples/positive.yaml"},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "E2E_CLI_031_RESULT",
					ResultsFormats: []string{"json", "sarif", "glsast", "html", "sonarqube", "junit", "cyclonedx", "asff"},
				},
				{
					ResultsFile:    "E2E_CLI_031_RESULT_CIS",
					ResultsFormats: []string{"junit", "json-cis"},
				},
			},
			UseMock: []bool{false, true},
		},
		WantStatus: []int{50, 50},
	}

	Tests = append(Tests, testSample)
}

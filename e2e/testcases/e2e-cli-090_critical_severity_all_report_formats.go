package testcases

// E2E-CLI-090 - Kics scan command with --report-formats and --output-path flags
// should export the results based on the formats provided by this flag, with critical severity
func init() { //nolint
	testSample := TestCase{
		Name: "should export the results based on the formats provided by this flag, with critical severity [E2E-CLI-090]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_090_RESULT",
					"--report-formats", "asff,codeclimate,csv,cyclonedx,glsast,html,json,junit,pdf,sarif,sonarqube",
					"-p", "\"/path/test/fixtures/test_critical_custom_queries/amazon_mq_broker_encryption_disabled/test\"",
					"-q", "\"/path/test/fixtures/test_critical_custom_queries/amazon_mq_broker_encryption_disabled/query\"",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "E2E_CLI_090_RESULT",
					ResultsFormats: []string{"asff", "codeclimate", "csv", "cyclonedx", "glsast", "html", "json", "junit", "pdf", "sarif", "sonarqube"},
				},
			},
		},
		WantStatus: []int{60},
	}

	Tests = append(Tests, testSample)
}

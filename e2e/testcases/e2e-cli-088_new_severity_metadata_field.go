package testcases

// E2E-CLI-088 - KICS scan with new severity metadata field
// should perform a scan successfully giving results with new severity metadata field and return exit code 60 according to the severity
func init() { //nolint
	testSample := TestCase{
		Name: "should perform a scans successfully giving results with new severity and return exit code according to new severity [E2E-CLI-088]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_088_RESULT",
					"-p", "\"/path/test/fixtures/test_new_severity/test\"",
					"-q", "\"/path/test/fixtures/test_new_severity/info\"",
				},
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_088_RESULT_2",
					"-p", "\"/path/test/fixtures/test_new_severity/test\"",
					"-q", "\"/path/test/fixtures/test_new_severity/low\"",
				},
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_088_RESULT_3",
					"-p", "\"/path/test/fixtures/test_new_severity/test\"",
					"-q", "\"/path/test/fixtures/test_new_severity/medium\"",
				},
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_088_RESULT_4",
					"-p", "\"/path/test/fixtures/test_new_severity/test\"",
					"-q", "\"/path/test/fixtures/test_new_severity/high\"",
				},
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_088_RESULT_5",
					"-p", "\"/path/test/fixtures/test_new_severity/test\"",
					"-q", "\"/path/test/fixtures/test_new_severity/critical\"",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile: "E2E_CLI_088_RESULT",
				},
				{
					ResultsFile: "E2E_CLI_088_RESULT_2",
				},
				{
					ResultsFile: "E2E_CLI_088_RESULT_3",
				},
				{
					ResultsFile: "E2E_CLI_088_RESULT_4",
				},
				{
					ResultsFile: "E2E_CLI_088_RESULT_5",
				},
			},
		},
		WantStatus: []int{60},
	}

	Tests = append(Tests, testSample)
}

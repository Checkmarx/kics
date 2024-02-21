package testcases

// E2E-CLI-088 - KICS scan with new severity metadata field
// should perform a scan successfully giving results with new severity metadata field and return exit code according to the severity
func init() { //nolint
	testSample01 := TestCase{
		Name: "should perform a scans successfully giving results with new severity and return exit code " +
			"according to new severity [E2E-CLI-08_1]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_088_RESULT",
					"-p", "\"/path/test/fixtures/test_new_severity/test\"",
					"-q", "\"/path/test/fixtures/test_new_severity/info\"",
					"--new-severities",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile: "E2E_CLI_088_RESULT",
				},
			},
		},
		WantStatus: []int{20},
	}
	testSample02 := TestCase{
		Name: "should perform a scans successfully giving results with new severity and return exit code " +
			"according to new severity [E2E-CLI-088_2]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_088_RESULT_2",
					"-p", "\"/path/test/fixtures/test_new_severity/test\"",
					"-q", "\"/path/test/fixtures/test_new_severity/low\"",
					"--new-severities",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile: "E2E_CLI_088_RESULT_2",
				},
			},
		},
		WantStatus: []int{30, 40, 50, 60},
	}
	testSample03 := TestCase{
		Name: "should perform a scans successfully giving results with new severity and return exit code " +
			"according to new severity [E2E-CLI-088_3]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_088_RESULT_3",
					"-p", "\"/path/test/fixtures/test_new_severity/test\"",
					"-q", "\"/path/test/fixtures/test_new_severity/medium\"",
					"--new-severities",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile: "E2E_CLI_088_RESULT_3",
				},
			},
		},
		WantStatus: []int{40},
	}
	testSample04 := TestCase{
		Name: "should perform a scans successfully giving results with new severity and return exit code " +
			"according to new severity [E2E-CLI-088_4]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_088_RESULT_4",
					"-p", "\"/path/test/fixtures/test_new_severity/test\"",
					"-q", "\"/path/test/fixtures/test_new_severity/high\"",
					"--new-severities",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile: "E2E_CLI_088_RESULT_4",
				},
			},
		},
		WantStatus: []int{50},
	}
	testSample05 := TestCase{
		Name: "should perform a scans successfully giving results with new severity and return exit code " +
			"according to new severity [E2E-CLI-088_5]",
		Args: args{
			Args: []cmdArgs{

				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_088_RESULT_5",
					"-p", "\"/path/test/fixtures/test_new_severity/test\"",
					"-q", "\"/path/test/fixtures/test_new_severity/critical\"",
					"--new-severities",
				},
			},
			ExpectedResult: []ResultsValidation{

				{
					ResultsFile: "E2E_CLI_088_RESULT_5",
				},
			},
		},
		WantStatus: []int{60},
	}

	Tests = append(Tests, testSample01, testSample02, testSample03, testSample04, testSample05)

}

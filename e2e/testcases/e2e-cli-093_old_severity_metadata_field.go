package testcases

var stringToTest = "should perform a scans successfully giving results with old severity and return exit code "

// E2E-CLI-093 - KICS scan with old severity metadata field
// should perform a scan successfully giving results with old severity metadata field and return exit code according to the severity
func init() { //nolint
	testSample01 := TestCase{
		Name: stringToTest +
			"according to old severity [E2E-CLI-093_1]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_093_RESULT",
					"-p", "\"/path/test/fixtures/test_old_severity/test\"",
					"-q", "\"/path/test/fixtures/test_old_severity/info\"",
					"--old-severities",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile: "E2E_CLI_093_RESULT",
				},
			},
		},
		WantStatus: []int{20},
	}
	testSample02 := TestCase{
		Name: stringToTest +
			"according to old severity [E2E-CLI-093_2]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_093_RESULT_2",
					"-p", "\"/path/test/fixtures/test_old_severity/test\"",
					"-q", "\"/path/test/fixtures/test_old_severity/low\"",
					"--old-severities",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile: "E2E_CLI_093_RESULT_2",
				},
			},
		},
		WantStatus: []int{30, 40, 50, 60},
	}
	testSample03 := TestCase{
		Name: stringToTest +
			"according to old severity [E2E-CLI-093_3]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_093_RESULT_3",
					"-p", "\"/path/test/fixtures/test_old_severity/test\"",
					"-q", "\"/path/test/fixtures/test_old_severity/medium\"",
					"--old-severities",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile: "E2E_CLI_093_RESULT_3",
				},
			},
		},
		WantStatus: []int{40},
	}
	testSample04 := TestCase{
		Name: stringToTest +
			"according to old severity [E2E-CLI-093_4]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_093_RESULT_4",
					"-p", "\"/path/test/fixtures/test_old_severity/test\"",
					"-q", "\"/path/test/fixtures/test_old_severity/high\"",
					"--old-severities",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile: "E2E_CLI_093_RESULT_4",
				},
			},
		},
		WantStatus: []int{50},
	}
	testSample05 := TestCase{
		Name: stringToTest +
			"according to old severity [E2E-CLI-093_5]",
		Args: args{
			Args: []cmdArgs{

				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_093_RESULT_5",
					"-p", "\"/path/test/fixtures/test_old_severity/test\"",
					"-q", "\"/path/test/fixtures/test_old_severity/critical\"",
					"--old-severities",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile: "E2E_CLI_093_RESULT_5",
				},
			},
		},
		WantStatus: []int{60},
	}
	Tests = append(Tests, testSample01, testSample02, testSample03, testSample04, testSample05)
}

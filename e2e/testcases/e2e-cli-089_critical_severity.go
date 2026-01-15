package testcases

// E2E-CLI-089 - KICS scan
// should perform a scan successfully giving results with critical severity and return exit code 60
func init() { //nolint
	testSample := TestCase{
		Name: "should perform a scan successfully giving results with critical severity and return exit code 60 [E2E-CLI-089]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_089_RESULT",
					"-p", "\"/path/test/fixtures/test_critical_severity/run_block_injection/test\"",
					"-q", "\"/path/test/fixtures/test_critical_severity/run_block_injection/query\"",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile: "E2E_CLI_089_RESULT",
				},
			},
		},
		WantStatus: []int{60},
	}

	Tests = append(Tests, testSample)
}

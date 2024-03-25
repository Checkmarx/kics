package testcases

// E2E-CLI-094 - KICS scan
// should perform a scan successfully giving results with similarity ids unique
func init() { //nolint
	testSample := TestCase{
		Name: "should perform a scan successfully giving results with similarity ids unique [E2E-CLI-094]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_094_RESULT",
					"-p", "\"/path/test/fixtures/test_critical_severity/run_block_injection/test\"",
					"-q", "\"/path/test/fixtures/test_critical_severity/run_block_injection/query\"",
					"-i", "bb9ac4f7-e13b-423d-a010-c74a1bfbe492",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile: "E2E_CLI_094_RESULT",
				},
			},
		},
		WantStatus: []int{60},
	}

	Tests = append(Tests, testSample)
}

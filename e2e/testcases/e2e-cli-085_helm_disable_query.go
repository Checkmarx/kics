package testcases

// E2E-CLI-085 - KICS  scan
// should perform a scan and return zero results ignoring the query
func init() { //nolint
	testSample := TestCase{
		Name: "should perform a scan and return zero results ignoring the query [E2E-CLI-085]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_085_RESULT",
					"-p", "\"/path/test/fixtures/helm_disable_query\"",
					"-i", "b7652612-de4e-4466-a0bf-1cd81f0c6063",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "E2E_CLI_085_RESULT",
					ResultsFormats: []string{"json"},
				},
			},
		},
		WantStatus: []int{0},
	}

	Tests = append(Tests, testSample)
}

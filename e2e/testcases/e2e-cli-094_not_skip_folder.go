package testcases

// E2E-CLI-094 - KICS scan folder, when size bigger than limit
// should perform a scan successfully and not skip a folder when the sum of the size of the file is higher than the limit
func init() { //nolint
	testSample := TestCase{
		Name: "E2E-CLI-094 - KICS scan folder, when size bigger than limit [E2E-CLI-094]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_094_RESULT",
					"-p", "\"/path/e2e/fixtures/samples/bigger_than_limit\"",
					"-i", "2d8c175a-6d90-412b-8b0e-e034ea49a1fe",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "E2E_CLI_094_RESULT",
					ResultsFormats: []string{"json"},
				},
			},
		},
		WantStatus: []int{40},
	}

	Tests = append(Tests, testSample)
}

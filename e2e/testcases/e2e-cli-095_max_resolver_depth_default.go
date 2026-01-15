package testcases

// E2E-CLI-095 - KICS  scan and ignore references
// should perform the scan successfully and return exit code 0
// this test sample contains a circular loop. It will stop after 15 iterations, having parsed 6887 lines
func init() { //nolint
	testSample := TestCase{
		Name: "should perform a valid scan and resolve references [E2E-CLI-095]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_095_RESULT",
					"-p", "\"/path/test/fixtures/resolve_circular_loop\"",
					"-i", "a88baa34-e2ad-44ea-ad6f-8cac87bc7c71",
					"--max-resolver-depth", "15",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "E2E_CLI_095_RESULT",
					ResultsFormats: []string{"json"},
				},
			},
		},
		WantStatus: []int{0},
	}

	Tests = append(Tests, testSample)
}

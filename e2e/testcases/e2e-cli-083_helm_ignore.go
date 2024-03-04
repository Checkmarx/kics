package testcases

// E2E-CLI-083 - KICS  scan
// should perform a scan and return zero results ignoring the file
func init() { //nolint
	testSample := TestCase{
		Name: "should perform a scan and return zero results ignoring the file [E2E-CLI-083]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_083_RESULT",
					"-p", "\"/path/test/fixtures/helm_ignore\"",
					"-i", "b7652612-de4e-4466-a0bf-1cd81f0c6063",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "E2E_CLI_083_RESULT",
					ResultsFormats: []string{"json"},
				},
			},
		},
		WantStatus: []int{0},
	}

	Tests = append(Tests, testSample)
}

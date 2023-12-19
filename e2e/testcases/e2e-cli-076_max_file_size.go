package testcases

// E2E-CLI-075 - KICS  scan
// should perform the scan successfully detect ansible and return result 40
func init() { //nolint
	testSample := TestCase{
		Name: "should perform a valid scan and and detect ansible [E2E-CLI-075]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_076_RESULT",
					"-p", "\"/path/test/fixtures/max_file_size\"",
					"--max-file-size", "4",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "E2E_CLI_076_RESULT",
					ResultsFormats: []string{"json"},
				},
			},
		},
		WantStatus: []int{00},
	}

	Tests = append(Tests, testSample)
}

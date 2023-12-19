package testcases

// E2E-CLI-076 - KICS  scan
// should perform a scan without detecting anything since no files are scanned because of max file size
func init() { //nolint
	testSample := TestCase{
		Name: "should perform a scan without detecting anything since no files are scanned because of max file size [E2E-CLI-076]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_076_RESULT",
					"-p", "\"/path/test/fixtures/max_file_size\"",
					"--max-file-size", "3",
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

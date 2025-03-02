package testcases

// E2E-CLI-098
// should perform the scan successfully and return exit code 50
// this test sample contains a different query_id
// that is not a UUID, but contains a prefix ('t:', 'p:', or 'a:') + uint64
func init() { //nolint
	testSample := TestCase{
		Name: "should perform a valid scan and return one HIGH result [E2E-CLI-098]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_098_RESULT",
					"-q", "\"/path/test/fixtures/new_queryid_validation\"",
					"-p", "\"/path/test/fixtures/new_queryid_validation/Dockerfile\"",
					// QueryID 'a:123' does not exist, however, since the first one does, it should perform the scan successfully
					"-i", "t:8820143918834007824,a:123",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "E2E_CLI_098_RESULT",
					ResultsFormats: []string{"json"},
				},
			},
		},
		WantStatus: []int{50},
	}

	Tests = append(Tests, testSample)
}

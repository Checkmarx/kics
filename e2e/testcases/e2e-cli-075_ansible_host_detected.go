package testcases

// E2E-CLI-075 - KICS  scan
// should perform the scan successfully detect ansible and return result 40
func init() { //nolint
	testSample := TestCase{
		Name: "should perform a valid scan and and detect ansible [E2E-CLI-075]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_075_RESULT",
					"-p", "\"/path/test/fixtures/analyzer_test_ansible_host/e2e\"",
					"-i", "1b2bf3ff-31e9-460e-bbfb-45e48f4f20cc",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "E2E_CLI_075_RESULT",
					ResultsFormats: []string{"json"},
				},
			},
		},
		WantStatus: []int{40},
	}

	Tests = append(Tests, testSample)
}

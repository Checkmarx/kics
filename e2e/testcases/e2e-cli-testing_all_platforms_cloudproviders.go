package testcases

// e2e-cli-testing_all_platforms_cloudproviders - KICS scan
// should perform a scan successfully for all supported platforms and cloud providers
func init() { //nolint
	testSample := TestCase{
		Name: "should perform a scan successfully for all supported platforms and cloud providers",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_TEST_ALL_PLATFORMS_CLOUDPROVIDERS",
					"-p", "\"/path/test/fixtures/test_all_platforms_cloudproviders\"",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile: "E2E_CLI_TEST_ALL_PLATFORMS_CLOUDPROVIDERS",
				},
			},
		},
		WantStatus: []int{60},
	}

	Tests = append(Tests, testSample)
}

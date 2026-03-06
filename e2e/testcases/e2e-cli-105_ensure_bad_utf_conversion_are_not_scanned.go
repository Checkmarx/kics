package testcases

// E2E-CLI-105 - KICS should ignore files with bad UTF-8 conversion and not include them in the scan files
func init() { //nolint
	testSample := TestCase{
		Name: "should ignore files with bad UTF-8 conversion and not include them in the scan files [E2E-CLI-105]",
		Args: args{
			Args: []cmdArgs{
				[]string{
					"scan",
					"-p", "/path/test/fixtures/mix_utf8_and_non_utf/",
					"--payload-path", "/path/e2e/output/E2E_CLI_105_PAYLOAD",
				},
			},
			ExpectedPayload: []string{
				"E2E_CLI_105_PAYLOAD.json",
			},
		},
		WantStatus: []int{0},
	}

	Tests = append(Tests, testSample)
}

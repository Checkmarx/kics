package testcases

// E2E-CLI-103 - KICS Bicep scan should not include existing resources in payload file
// Tests that resources marked with 'existing' keyword are excluded from payload output
func init() { //nolint
	testSample := TestCase{
		Name: "should perform a scan on bicep file with existing resources and return exit code 0 [E2E-CLI-103]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "--payload-path", "/path/e2e/output/E2E_CLI_103_PAYLOAD",
					"-p", "/path/test/fixtures/bicep_test/existing_parent.bicep",
				},
			},
			ExpectedPayload: []string{
				"E2E_CLI_103_PAYLOAD.json",
			},
		},
		WantStatus: []int{0}, // Since existing resources are ignored, no vulnerabilities should be found for them
	}

	Tests = append(Tests, testSample)
}

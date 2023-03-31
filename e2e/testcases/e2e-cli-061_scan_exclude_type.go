package testcases

// E2E-CLI-011 - KICS  scan with a valid case insensitive --type flag
// should perform the scan successfully and return exit code 50
func init() { //nolint
	testSample := TestCase{
		Name: "should perform a valid scan with -t flag [E2E-CLI-011]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-p", "/path/test/fixtures/analyzer_test",
					"--silent", "--payload-path", "/path/e2e/output/E2E_CLI_061_PAYLOAD.json", "--exclude-type", "azureResourceManager, CloudFormation, DockerCompose, knative, serverlssFW"},
			},
			ExpectedPayload: []string{
				"E2E_CLI_061_PAYLOAD.json",
			},
		},
		WantStatus: []int{50},
	}

	Tests = append(Tests, testSample)
}

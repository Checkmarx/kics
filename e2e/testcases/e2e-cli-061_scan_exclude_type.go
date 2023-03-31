package testcases

// E2E-CLI-061 - KICS  scan with a valid case insensitive --exclude-type flag
// should perform the scan successfully and return exit code 50
func init() { //nolint
	testSample := TestCase{
		Name: "should perform a valid scan with --exclude-type flag [E2E-CLI-061]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-p", "/path/test/fixtures/analyzer_test",
					"--silent", "--payload-path", "/path/e2e/output/E2E_CLI_061_PAYLOAD.json", "--exclude-type",
					"AzureResourceManager,CloudFormation,DockerCompose,Knative,ServerlessFW"},
			},
			ExpectedPayload: []string{
				"E2E_CLI_061_PAYLOAD.json",
			},
		},
		WantStatus: []int{50},
	}

	Tests = append(Tests, testSample)
}

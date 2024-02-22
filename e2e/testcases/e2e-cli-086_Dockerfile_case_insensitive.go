package testcases

// E2E-CLI-086 - KICS  scan
// should perform a scan and return results in different files with name DockerFile
func init() { //nolint
	testSample := TestCase{
		Name: "should perform a scan and return results in different files with name DockerFile [E2E-CLI-086]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_086_RESULT",
					"-p", "\"/path/test/fixtures/helm_disable_query\"",
					"-i", "77783205-c4ca-4f80-bb80-c777f267c547",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "E2E_CLI_086_RESULT",
					ResultsFormats: []string{"json"},
				},
			},
		},
		WantStatus: []int{30},
	}

	Tests = append(Tests, testSample)
}

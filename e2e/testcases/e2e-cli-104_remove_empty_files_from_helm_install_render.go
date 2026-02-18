package testcases

// E2E-CLI-104 - KICS should perform a scan and remove empty files from helm install render
func init() { //nolint
	testSample := TestCase{
		Name: "should remove empty files from helm install render [E2E-CLI-104]",
		Args: args{
			Args: []cmdArgs{
				[]string{
					"scan",
					"-p", "/path/test/fixtures/helm_empty_file",
					"-i", "611ab018-c4aa-4ba2-b0f6-a448337509a6",
					"--kics_compute_new_simid",
					"--payload-path", "/path/e2e/output/E2E_CLI_104_PAYLOAD",
					"-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_104_RESULT",
				},
			},
			ExpectedPayload: []string{
				"E2E_CLI_104_PAYLOAD.json",
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "E2E_CLI_104_RESULT",
					ResultsFormats: []string{"json"},
				},
			},
		},
		WantStatus: []int{40},
	}

	Tests = append(Tests, testSample)
}

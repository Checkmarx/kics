package testcases

// E2E-CLI-033 - KICS scan command with --output-path and --payload-path flags
// should perform a scan and create result file(s) and payload file
func init() { //nolint
	testSample := TestCase{
		Name: " should perform a scan and create a result and payload file [E2E-CLI-033]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan",
					"--output-path", "/path/e2e/output",
					"--output-name", "E2E_CLI_033_RESULT",
					"--report-formats", "json,sarif,glsast,codeclimate",
					"--payload-path", "/path/e2e/output/E2E_CLI_033_PAYLOAD.json",
					"-p", "/path/e2e/fixtures/samples/terraform-single.tf",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "E2E_CLI_033_RESULT",
					ResultsFormats: []string{"json", "sarif", "glsast", "codeclimate"},
				},
			},
			ExpectedPayload: []string{
				"E2E_CLI_033_PAYLOAD.json",
			},
		},
		WantStatus: []int{40},
	}

	Tests = append(Tests, testSample)
}

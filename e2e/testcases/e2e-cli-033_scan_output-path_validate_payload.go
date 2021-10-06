package testcases

// E2E-CLI-033 - KICS scan command with --output-path and --payload-path flags
// should perform a scan and create result file(s) and payload file
func init() { //nolint
	testSample := TestCase{
		Name: " should perform a scan and create a result and payload file [E2E-CLI-033]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan",
					"--output-path", "output",
					"--output-name", "E2E_CLI_033_RESULT",
					"--report-formats", "json,sarif,glsast",
					"--payload-path", "output/E2E_CLI_033_PAYLOAD.json",
					"-q", "../assets/queries", "-p", "fixtures/samples/terraform-single.tf",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "E2E_CLI_033_RESULT",
					ResultsFormats: []string{"json", "sarif", "glsast"},
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

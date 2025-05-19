package testcases

// E2E-CLI-100 - KICS should scan a folder containing only unsupported FHIR files
// and successfully skip them without errors, returning exit code 0
func init() { //nolint
	testSample := TestCase{
		Name: "should scan a folder with FHIR files and skip them successfully [E2E-CLI-100]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_100_RESULT", "-v",
					"-p", "\"/path/e2e/fixtures/samples/fhir-samples\"",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "E2E_CLI_100_RESULT",
					ResultsFormats: []string{"json"},
				},
			},
		},
		WantStatus: []int{0},
	}

	Tests = append(Tests, testSample)
}

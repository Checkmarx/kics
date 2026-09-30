package testcases

// E2E-CLI-051 - Kics scan with specific queries
// should return results for the provided queries
func init() { //nolint
	testSample := TestCase{
		Name: "should return results for the provided queries [E2E-CLI-051]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan",
					"-p", "/path/e2e/fixtures/samples/terraform.tf", "--no-color",
					"--include-queries", "487f4be7-3fd9-4506-a07a-eae252180c08,cfdcabb0-fc06-427c-865b-c59f13e898ce",
					"-o", "/path/e2e/output", "--output-name", "/path/e2e/output/E2E_CLI_051_RESULTS.json"},

				[]string{"scan",
					"-p", "/path/e2e/fixtures/samples/terraform.tf", "--no-color",
					"-o", "/path/e2e/output", "--output-name", "/path/e2e/output/E2E_CLI_051_RESULTS_2.json"},
			},
			UseMock: []bool{true, true},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "E2E_CLI_051_RESULTS",
					ResultsFormats: []string{"json"},
				},
				{
					ResultsFile:    "E2E_CLI_051_RESULTS_2",
					ResultsFormats: []string{"json"},
				},
			},
		},
		WantStatus: []int{50, 50},
	}

	Tests = append(Tests, testSample)
}

package testcases

// E2E-CLI-052 - Kics scan with a custom CIS descriptions env variable
// should load and display the correct CIS descriptions (provided by the custom server)
func init() { //nolint
	testSample := TestCase{
		Name: "should load descriptions from a custom server [E2E-CLI-052]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan",
					"-p", "/path/e2e/fixtures/samples/terraform.tf", "--no-color",
					"--include-queries", "487f4be7-3fd9-4506-a07a-eae252180c08,cfdcabb0-fc06-427c-865b-c59f13e898ce",
					"-o", "/path/e2e/output", "--output-name", "/path/e2e/output/E2E_CLI_052_RESULTS_ALL_HAVE_CIS.json"},

				[]string{"scan",
					"-p", "/path/e2e/fixtures/samples/terraform.tf", "--no-color",
					"-o", "/path/e2e/output", "--output-name", "/path/e2e/output/E2E_CLI_052_RESULTS_SOME_HAVE_CIS.json"},
			},
			UseMock: []bool{true, true},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "E2E_CLI_052_RESULTS_ALL_HAVE_CIS",
					ResultsFormats: []string{"json-cis"},
				},
				{
					ResultsFile:    "E2E_CLI_052_RESULTS_SOME_HAVE_CIS",
					ResultsFormats: []string{"json"},
				},
			},
		},
		WantStatus: []int{50, 50},
	}

	Tests = append(Tests, testSample)
}

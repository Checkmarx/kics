package testcases

// E2E-CLI-052 - Kics scan with a custom CIS descriptions env variable
// should load and display the correct CIS descriptions (provided by the custom server)
func init() { //nolint
	testSample := TestCase{
		Name: "should load descriptions from a custom server [E2E-CLI-052]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "--queries-path", "../assets/queries",
					"-p", "fixtures/samples/terraform.tf", "--no-color",
					"--include-queries", "487f4be7-3fd9-4506-a07a-eae252180c08,cfdcabb0-fc06-427c-865b-c59f13e898ce",
					"-o", "output", "--output-name", "output/E2E_CLI_052_RESULT_CIS.json"},

				[]string{"scan", "--queries-path", "../assets/queries",
					"-p", "fixtures/samples/terraform.tf", "--no-color",
					"--include-queries", "487f4be7-3fd9-4506-a07a-eae252180c08,cfdcabb0-fc06-427c-865b-c59f13e898ce",
					"-o", "output", "--output-name", "output/E2E_CLI_052_RESULT.json"},
			},
			UseMock: []bool{true, false},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "E2E_CLI_052_RESULT_CIS",
					ResultsFormats: []string{"json-cis"},
				},
				{
					ResultsFile:    "E2E_CLI_052_RESULT",
					ResultsFormats: []string{"json"},
				},
			},
		},
		WantStatus: []int{50, 50},
	}

	Tests = append(Tests, testSample)
}

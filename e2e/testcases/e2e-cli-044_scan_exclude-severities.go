package testcases

// E2E-CLI-044 - Kics scan command with --exclude-severities
// should only execute query-ids provided in the flag.
func init() { //nolint
	testSample := TestCase{
		Name: "should exclude queries by given severities [E2E-CLI-044]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-q", "../assets/queries", "-p", "fixtures/samples/positive.yaml",
					"--output-path", "output", "--output-name", "E2E_CLI_044_RESULT",
					"--exclude-severities", "HIGH"},

				[]string{"scan", "-q", "../assets/queries", "-p", "fixtures/samples/positive.yaml",
					"--output-path", "output", "--output-name", "E2E_CLI_044_RESULT",
					"--exclude-severities", "HIGH,MEDIUM,LOW,INFO"},

				[]string{"scan", "-q", "../assets/queries", "-p", "fixtures/samples/terraform.tf",
					"--output-path", "output", "--output-name", "E2E_CLI_044_RESULT",
					"--exclude-severities"},

				[]string{"scan", "-q", "../assets/queries", "-p", "fixtures/samples/terraform.tf",
					"--output-path", "output", "--output-name", "E2E_CLI_044_RESULT",
					"--exclude-severities", "HIGH,MEDIUM,LOW"},
			},
		},
		WantStatus: []int{40, 0, 126, 20},
	}

	Tests = append(Tests, testSample)
}

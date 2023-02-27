package testcases

// E2E-CLI-044 - Kics scan command with --exclude-severities
// should exclude results with the specified severities
func init() { //nolint
	testSample := TestCase{
		Name: "should exclude queries by given severities [E2E-CLI-044]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-p", "/path/e2e/fixtures/samples/positive.yaml",
					"--output-path", "/path/e2e/output", "--output-name", "E2E_CLI_044_RESULT",
					"--exclude-severities", "HIGH"},

				[]string{"scan", "-p", "/path/e2e/fixtures/samples/positive.yaml",
					"--output-path", "/path/e2e/output", "--output-name", "E2E_CLI_044_RESULT",
					"--exclude-severities", "HIGH,MEDIUM,LOW,INFO"},

				[]string{"scan", "-p", "/path/e2e/fixtures/samples/terraform.tf",
					"--output-path", "/path/e2e/output", "--output-name", "E2E_CLI_044_RESULT",
					"--exclude-severities"},

				[]string{"scan", "-p", "/path/e2e/fixtures/samples/terraform.tf",
					"--output-path", "/path/e2e/output", "--output-name", "E2E_CLI_044_RESULT",
					"--exclude-severities", "HIGH,MEDIUM,LOW"},
			},
		},
		WantStatus: []int{40, 0, 126, 20},
	}

	Tests = append(Tests, testSample)
}

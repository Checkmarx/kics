package testcases

// E2E-CLI-045 - Kics scan command with --disable-secrets
// should not execute secret based queries.
func init() { //nolint
	testSample := TestCase{
		Name: "should not execute secret queries [E2E-CLI-045]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-p", "/path/e2e/fixtures/samples/terraform.tf",
					"--include-queries", "487f4be7-3fd9-4506-a07a-eae252180c08"},

				[]string{"scan", "-p", "/path/e2e/fixtures/samples/terraform.tf",
					"--include-queries", "487f4be7-3fd9-4506-a07a-eae252180c08",
					"--disable-secrets"},

				[]string{"scan", "-p", "/path/e2e/fixtures/samples/terraform.tf",
					"--include-queries", "487f4be7-3fd9-4506-a07a-eae252180c08,e38a8e0a-b88b-4902-b3fe-b0fcb17d5c10",
					"--disable-secrets"},
			},
		},
		WantStatus: []int{50, 0, 20},
	}

	Tests = append(Tests, testSample)
}

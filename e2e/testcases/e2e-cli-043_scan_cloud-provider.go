package testcases

// E2E-CLI-043 - Kics scan command with --cloud-provider
// should execute only queries that have the same provider as given in the flag.
func init() { //nolint
	testSample := TestCase{
		Name: "should execute only queries of specific cloud provider [E2E-CLI-043]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "", "/path/e2e/fixtures/samples/positive.yaml",
					"--cloud-provider", "none"},

				[]string{"scan", "-p", "/path/e2e/fixtures/samples/positive.yaml",
					"--cloud-provider"},

				[]string{"scan", "-p", "/path/e2e/fixtures/samples/positive.yaml",
					"--cloud-provider", "aWs"},
			},
		},
		WantStatus: []int{126, 126, 50},
	}

	Tests = append(Tests, testSample)
}

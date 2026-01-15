package testcases

// E2E-CLI-049 - Kics scan command with --libraries-path
// should load libraries from the provided path.
func init() { //nolint
	testSample := TestCase{
		Name: "should load libraries from the provided path [E2E-CLI-049]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "--silent", "-p", "/path/e2e/fixtures/samples/terraform-single.tf",
					"--libraries-path", "/path/e2e/fixtures/samples/libraries"},

				[]string{"scan", "--silent", "-p", "/path/e2e/fixtures/samples/positive.yaml",
					"--libraries-path", "/path/e2e/fixtures/samples/libraries"},

				[]string{"scan", "--silent", "-p", "/path/e2e/fixtures/samples/positive.yaml",
					"--libraries-path", "/path/e2e/fixtures/samples/not-exists-folder"},
			},
		},
		WantStatus: []int{0, 50, 126},
	}

	Tests = append(Tests, testSample)
}

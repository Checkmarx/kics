package testcases

// E2E-CLI-049 - Kics scan command with --libraries-path
// should load libraries from the provided path.
func init() { //nolint
	testSample := TestCase{
		Name: "should load libraries from the provided path [E2E-CLI-049]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "--silent", "-q", "../assets/queries", "-p", "fixtures/samples/terraform-single.tf",
					"--libraries-path", "fixtures/samples/libraries"},

				[]string{"scan", "--silent", "-q", "../assets/queries", "-p", "fixtures/samples/positive.yaml",
					"--libraries-path", "fixtures/samples/libraries"},

				[]string{"scan", "--silent", "-q", "../assets/queries", "-p", "fixtures/samples/positive.yaml",
					"--libraries-path", "fixtures/samples/not-exists-folder"},
			},
		},
		WantStatus: []int{0, 50, 126},
	}

	Tests = append(Tests, testSample)
}

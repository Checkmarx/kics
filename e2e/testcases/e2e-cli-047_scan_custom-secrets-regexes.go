package testcases

// E2E-CLI-048 - Kics scan command with --secrets-regexes-path
// should load custom secrets rules from provided path.
func init() { //nolint
	testSample := TestCase{
		Name: "should load custom secrets rules from provided path [E2E-CLI-048]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "--silent", "-p", "/path/e2e/fixtures/samples/terraform-secret.tf",
					"--secrets-regexes-path", "/path/e2e/fixtures/samples/secrets/regex_rules_48_valid.json"},

				[]string{"scan", "--silent", "-p", "/path/e2e/fixtures/samples/terraform-secret.tf",
					"--secrets-regexes-path", "/path/e2e/fixtures/samples/secrets/regex_rules_48_valid.json",
					"--exclude-queries", "487f4be7-3fd9-4506-a07a-eae252180c08"},

				[]string{"scan", "--silent", "-p", "/path/e2e/fixtures/samples/terraform-secret.tf",
					"--secrets-regexes-path", "/path/e2e/fixtures/samples/secrets/regex_rules_48_empty.json"},

				[]string{"scan", "--silent", "-p", "/path/e2e/fixtures/samples/terraform-secret.tf",
					"--secrets-regexes-path", "/path/e2e/fixtures/samples/secrets/regex_rules_48_invalid_regex.json"},

				[]string{"scan", "--silent", "-p", "/path/e2e/fixtures/samples/terraform.tf",
					"--secrets-regexes-path", "not-exists-folder"},

				[]string{"scan", "--silent", "-p", "/path/e2e/fixtures/samples/terraform.tf",
					"--secrets-regexes-path", "samples"},
			},
		},
		WantStatus: []int{50, 40, 40, 126, 126, 126},
	}

	Tests = append(Tests, testSample)
}

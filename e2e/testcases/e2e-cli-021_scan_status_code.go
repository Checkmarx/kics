package testcases

// E2E-CLI-021 - KICS can return different status code based in the scan results (High/Medium/Low..)
// when excluding categories/queries and losing results we can get a different status code.
func init() { //nolint
	testSample := TestCase{
		Name: "should validate the kics result status code [E2E-CLI-021]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan",
					"-p", "/path/e2e/fixtures/samples/positive.yaml"},

				[]string{"scan", "--exclude-categories",
					"Access Control,Availability,Backup,Best Practices,Build Process,Encryption," +
						"Insecure Configurations,Insecure Defaults,Networking and Firewall,Observability," +
						"Resource Management,Secret Management,Supply-Chain,Structure and Semantics",
					"-p", "/path/test/fixtures/all_auth_users_get_read_access/test/positive.tf"},
			},
		},
		WantStatus: []int{50, 0},
	}

	Tests = append(Tests, testSample)
}

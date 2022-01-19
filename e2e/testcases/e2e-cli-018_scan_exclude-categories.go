package testcases

// E2E-CLI-018  - KICS scan command with --exclude-categories flag
// should not run queries that are part of the provided categories.
func init() { //nolint
	testSample := TestCase{
		Name: "should exclude provided categories [E2E-CLI-018]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "--exclude-categories", "Observability,Insecure Configurations,Networking and Firewall", "-s",
					"-q", "../assets/queries", "-p", "fixtures/samples/terraform-single.tf"},
			},
		},
		WantStatus: []int{20},
	}

	Tests = append(Tests, testSample)
}

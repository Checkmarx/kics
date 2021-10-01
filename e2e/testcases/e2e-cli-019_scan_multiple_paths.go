package testcases

// E2E-CLI-019 - KICS scan with multiple paths
// should run a scan for all provided paths/files
func init() {
	testSample := TestCase{
		Name: "should run a scan in multiple paths [E2E-CLI-019]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "--silent", "-q", "../assets/queries", "-p", "fixtures/samples/terraform.tf,fixtures/samples/terraform-single.tf"},
			},
			ExpectedOut: []string{
				"E2E_CLI_019",
			},
		},
		WantStatus: []int{50},
	}

	Tests = append(Tests, testSample)
}

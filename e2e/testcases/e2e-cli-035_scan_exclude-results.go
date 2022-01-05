package testcases

// E2E-CLI-035 - KICS scan command with --exclude-results
// should not run/found results (similarityID) provided by this flag
func init() { //nolint
	testSample := TestCase{
		Name: "should exclude provided similarity ID results [E2E-CLI-035]",
		Args: args{
			Args: []cmdArgs{

				[]string{"scan",
					"--exclude-results",
					"2abf26c3014fc445da69d8d5bb862c1c511e8e16ad3a6c6f6e14c28aa0adac1d," +
						"4aa3f159f39767de53b49ed871977b8b499bf19b3b0865b1631042aa830598aa," +
						"83461a5eac8fed2264fac68a6d352d1ed752867a9b0a131afa9ba7e366159b59," +
						"aa346cd1642a83b40e221f96a43d88dbfacecdf1f8e5314c24145f8d35530197",
					"-q", "../assets/queries", "-p", "fixtures/samples/terraform-single.tf"},

				[]string{"scan", "--exclude-results", "-q", "../assets/queries", "-p", "fixtures/samples/terraform-single.tf"},
			},
		},

		WantStatus: []int{20, 126},
	}

	Tests = append(Tests, testSample)
}

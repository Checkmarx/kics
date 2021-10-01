package testcases

// E2E-CLI-020 - KICS scan with --exclude-queries flag
// should not run queries that was provided in this flag.
func init() {
	testSample := TestCase{
		Name: "should exclude provided queries [E2E-CLI-020]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "--exclude-queries", "15ffbacc-fa42-4f6f-a57d-2feac7365caa,0a494a6a-ebe2-48a0-9d77-cf9d5125e1b3", "-s",
					"-q", "../assets/queries", "-p", "fixtures/samples/terraform-single.tf"},
			},
		},
		WantStatus: []int{20},
	}

	Tests = append(Tests, testSample)
}

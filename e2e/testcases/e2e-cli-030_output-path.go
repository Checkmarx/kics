package testcases

// E2E-CLI-030 - Kics scan command with --output-path flags
// should export the result files to the path provided by this flag.
func init() { //nolint
	testSample := TestCase{
		Name: "should export the result files to provided path [E2E-CLI-030]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "--output-path", "output",
					"-q", "../assets/queries", "-p", "fixtures/samples/terraform-single.tf"},
			},
		},
		WantStatus: []int{40},
	}

	Tests = append(Tests, testSample)
}

package testcases

// E2E-CLI-051 - Kics scan command with --queries-path
// should load and execute queries found in the provided path
func init() { //nolint
	testSample := TestCase{
		Name: "should load and execute queries from a custom path [E2E-CLI-051]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "--queries-path", "fixtures/samples/queries/valid/single_query", "-p", "fixtures/samples/bom-positive.tf"},
				[]string{"scan", "--queries-path", "fixtures/samples/queries/invalid/invalid_metadata", "-p", "fixtures/samples/bom-positive.tf"},
				[]string{"scan", "--queries-path", "fixtures/samples/queries/invalid/missing_metadata", "-p", "fixtures/samples/bom-positive.tf"},
				[]string{"scan", "--queries-path", "fixtures/samples/invalid_path", "-p", "fixtures/samples/bom-positive.tf"},
			},
		},
		WantStatus: []int{50, 0, 0, 126},
	}

	Tests = append(Tests, testSample)
}

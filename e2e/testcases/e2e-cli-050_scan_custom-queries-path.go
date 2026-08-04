package testcases

// E2E-CLI-051 - Kics scan command with --queries-path
// should load and execute queries found in the provided path
func init() { //nolint
	testSample := TestCase{
		Name: "should load and execute queries from a custom path [E2E-CLI-051]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "--queries-path", "/path/e2e/fixtures/samples/queries/valid/single_query",
					"-p", "/path/e2e/fixtures/samples/bom-positive.tf"},
				[]string{"scan", "--queries-path", "/path/e2e/fixtures/samples/queries/invalid/invalid_metadata",
					"-p", "/path/e2e/fixtures/samples/bom-positive.tf"},
				[]string{"scan", "--queries-path", "/path/e2e/fixtures/samples/queries/invalid/missing_metadata", "-p",
					"/path/e2e/fixtures/samples/bom-positive.tf"},
				[]string{"scan", "--queries-path", "/path/e2e/fixtures/samples/invalid_path",
					"-p", "/path/e2e/fixtures/samples/bom-positive.tf"},
			},
		},
		WantStatus: []int{50, 0, 0, 126},
	}

	Tests = append(Tests, testSample)
}

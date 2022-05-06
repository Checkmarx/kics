package testcases

// E2E-CLI-020 - KICS scan with --exclude-queries flag
// should not run queries that was provided in this flag.
func init() { //nolint
	testSample := TestCase{
		Name: "should exclude provided queries [E2E-CLI-020]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan",
					"--exclude-queries", "fd54f200-402c-4333-a5a4-36ef6709af2f," +
						"d3499f6d-1651-41bb-a9a7-de925fea487b," +
						"b03a748a-542d-44f4-bb86-9199ab4fd2d5",
					"-s", "-p", "/path/e2e/fixtures/samples/single.dockerfile"},
			},
		},
		WantStatus: []int{20},
	}

	Tests = append(Tests, testSample)
}

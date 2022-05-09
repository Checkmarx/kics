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
					"449be223f73b808ffbfb61a17090408aaba9615eb57f79c74e7e9cf6190b57d7," +
						"d5a929b017b21438c2d42d4361f12941ea5b3d7f9eedfcb73848141b041d1f4d," +
						"82ab4f612e7f3e0fbed0ac72f8747fe81f94961f94ad8302121f17ef184acd22",
					"-p", "/path/e2e/fixtures/samples/single.dockerfile"},

				[]string{"scan", "--exclude-results", "-p", "/path/e2e/fixtures/samples/single.dockerfile"},
			},
		},
		WantStatus: []int{20, 126},
	}

	Tests = append(Tests, testSample)
}

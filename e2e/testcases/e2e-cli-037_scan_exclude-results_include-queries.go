package testcases

// E2E-CLI-037 - KICS scan command with --exclude-results and --include-queries
// should run only provided queries and does not run results (similarityID) provided by this flag
func init() { //nolint
	testSample := TestCase{
		Name: "should run only provided queries and exclude provided results [E2E-CLI-037]",
		Args: args{
			Args: []cmdArgs{

				[]string{"scan", "--include-queries", "e38a8e0a-b88b-4902-b3fe-b0fcb17d5c10",
					"--exclude-results", "77363db6350f38d12d51eae554b988852f3f7da1f7a05c030d51002492561cbd",
					"-p", "/path/e2e/fixtures/samples/terraform-single.tf"},

				[]string{"scan", "--include-queries", "e38a8e0a-b88b-4902-b3fe-b0fcb17d5c10",
					"--exclude-results", "d1c5f6aec84fd91ed24f5f06ccb8b6662e26c0202bcb5d4a58a1458c16456d20",
					"-p", "/path/e2e/fixtures/samples/terraform-single.tf"},
			},
		},

		WantStatus: []int{0, 20},
	}

	Tests = append(Tests, testSample)
}

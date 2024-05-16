package testcases

// E2E-CLI-097 - KICS scan
// should perform a scan successfully giving results with similarity ids unique without showing the old similarity id
func init() { //nolint
	testSample := TestCase{
		Name: "should perform a scan successfully giving results with similarity ids unique without showing the old similarity id [E2E-CLI-097]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_097_RESULT",
					"-p", "\"/path/test/fixtures/new_similarity_id\"",
					"-i", "bb9ac4f7-e13b-423d-a010-c74a1bfbe492",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile: "E2E_CLI_097_RESULT",
				},
			},
		},
		WantStatus: []int{40},
	}

	Tests = append(Tests, testSample)
}

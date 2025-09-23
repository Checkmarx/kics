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
					"-i", "1828a670-5957-4bc5-9974-47da228f75e2,cf34805e-3872-4c08-bf92-6ff7bb0cfadb",
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

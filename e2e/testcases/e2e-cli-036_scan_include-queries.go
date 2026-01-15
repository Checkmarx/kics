package testcases

// E2E-CLI-036 - KICS scan command with --include-queries
// should perform a scan running only the provided queries
func init() { //nolint
	testSample := TestCase{
		Name: "should perform a scan including only specific queries [E2E-CLI-036]",
		Args: args{
			Args: []cmdArgs{

				[]string{"scan", "-p", "/path/e2e/fixtures/samples/positive.yaml",
					"--output-path", "/path/e2e/output", "--output-name", "E2E_CLI_036_RESULT",
					"--include-queries", "275a3217-ca37-40c1-a6cf-bb57d245ab32,027a4b7a-8a59-4938-a04f-ed532512cf45," +
						"e415f8d3-fc2b-4f52-88ab-1129e8c8d3f5,105ba098-1e34-48cd-b0f2-a8a43a51bf9b,ad21e616-5026-4b9d-990d-5b007bfe679c," +
						"79d745f0-d5f3-46db-9504-bef73e9fd528,e200a6f3-c589-49ec-9143-7421d4a2c845,01d5a458-a6c4-452a-ac50-054d59275b7c," +
						"7f384a5f-b5a2-4d84-8ca3-ee0a5247becb,87482183-a8e7-4e42-a566-7a23ec231c16,4a1e6b34-1008-4e61-a5f2-1f7c276f8d14," +
						"d24389b4-b209-4ff0-8345-dc7a4569dcdd,5e6c9c68-8a82-408e-8749-ddad78cbb9c5"}, // Load Many Queries (13)

				[]string{"scan", "-p", "/path/e2e/fixtures/samples/positive.yaml",
					"--output-path", "/path/e2e/output", "--output-name", "E2E_CLI_036_RESULT_2",
					"--include-queries", "87482183-a8e7-4e42-a566-7a23ec231c16"}, // Load 1 query

				[]string{"scan", "-p", "/path/e2e/fixtures/samples/positive.yaml",
					"--include-queries", "87482183-a8e7-4e42-a566-7a23ec231c17"}, // Load 0 queries (valid, but doesn't exists)

				[]string{"scan", "-p", "/path/e2e/fixtures/samples/positive.yaml",
					"--include-queries", "87482183-a8e7-4e42-a566-7a23ec23KICS"}, // Invalid query ID

				[]string{"scan", "--include-queries", "cfdcabb0-fc06-427c-865b-c59f13e898ce",
					"-s", "-p", "/path/e2e/fixtures/samples/terraform.tf"},

				[]string{"scan", "--include-queries", "e38a8e0a-b88b-4902-b3fe-b0fcb17d5c10,15ffbacc-fa42-4f6f-a57d-2feac7365caa",
					"-s", "-p", "/path/e2e/fixtures/samples/terraform.tf"},

				[]string{"scan", "--include-queries", "e38a8e0a-b88b-4902-b3fe-b0fcb17d5c10",
					"-s", "-p", "/path/e2e/fixtures/samples/terraform.tf"},

				[]string{"scan", "--include-queries",
					"-p", "/path/e2e/fixtures/samples/terraform-single.tf"},
				[]string{"scan", "--include-queries",
					"--queries-path", "/path/assets/queries", "-p", "/path/e2e/fixtures/samples/terraform-single.tf"},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "E2E_CLI_036_RESULT",
					ResultsFormats: []string{"json"},
				},
				{
					ResultsFile:    "E2E_CLI_036_RESULT_2",
					ResultsFormats: []string{"json"},
				},
			},
		},

		WantStatus: []int{50, 40, 0, 126, 50, 40, 20, 126, 126},
	}

	Tests = append(Tests, testSample)
}

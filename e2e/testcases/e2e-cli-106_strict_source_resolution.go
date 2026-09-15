package testcases

// E2E-CLI-106 - KICS scan with --strict-source-resolution
// Verifies that path-traversal references in scanned content are rejected when
// strict mode is enabled, and resolved as before when disabled.
func init() { //nolint
	testSample := TestCase{
		Name: "should reject path-traversal references when --strict-source-resolution is set [E2E-CLI-106]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output/",
					"--output-name", "E2E_CLI_106_STRICT_RESULT",
					"-p", "\"/path/e2e/fixtures/samples/strict-source-resolution/scan\"",
					"--enable-openapi-refs",
					"--strict-source-resolution",
					"-d", "/path/e2e/output/E2E_CLI_106_STRICT_RESULT_PAYLOAD.json",
				},
				[]string{"scan", "-o", "/path/e2e/output/",
					"--output-name", "E2E_CLI_106_NON_STRICT_RESULT",
					"-p", "\"/path/e2e/fixtures/samples/strict-source-resolution/scan\"",
					"--enable-openapi-refs",
					"-d", "/path/e2e/output/E2E_CLI_106_NON_STRICT_RESULT_PAYLOAD.json",
				},
			},
			ExpectedPayload: []string{
				"E2E_CLI_106_STRICT_RESULT_PAYLOAD.json",
				"E2E_CLI_106_NON_STRICT_RESULT_PAYLOAD.json",
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "E2E_CLI_106_STRICT_RESULT",
					ResultsFormats: []string{"json"},
				},
				{
					ResultsFile:    "E2E_CLI_106_NON_STRICT_RESULT",
					ResultsFormats: []string{"json"},
				},
			},
		},
		WantStatus: []int{50, 50},
	}

	Tests = append(Tests, testSample)
}

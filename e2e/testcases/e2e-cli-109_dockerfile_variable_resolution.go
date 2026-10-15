package testcases

// E2E-CLI-109 - KICS scan
// should resolve ARG and ENV references in a dockerfile deterministically, even when a variable name is
// a prefix of another one (e.g. $APP and $APP_USER), so "Last User Is 'root'" is reported on every stage
// that runs as root and only on those
func init() { //nolint
	testSample := TestCase{
		Name: "should resolve dockerfile ARG and ENV variables with a common prefix [E2E-CLI-109]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_109_RESULT",
					"-p", "/path/e2e/fixtures/samples/dockerfile-variable-resolution.dockerfile",
					"--include-queries", "67fd0c4a-68cf-46d7-8c41-bc9fba7e40ae",
					"--payload-path", "/path/e2e/output/E2E_CLI_109_PAYLOAD.json",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "E2E_CLI_109_RESULT",
					ResultsFormats: []string{"json"},
				},
			},
			ExpectedPayload: []string{
				"E2E_CLI_109_PAYLOAD.json",
			},
		},
		WantStatus: []int{50},
	}

	Tests = append(Tests, testSample)
}

package testcases

// E2E-CLI-100 - KICS should scan a folder containing only unsupported files (FHIR, azure-pipelines-vscode)
// and successfully skip them without errors, returning exit code 0
func init() { //nolint
	testSampleFHIR := TestCase{
		Name: "should scan a folder with FHIR files and skip them successfully [E2E-CLI-100]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_100_RESULT", "-v",
					"-p", "\"/path/e2e/fixtures/samples/blacklisted-files/fhir\"",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "E2E_CLI_100_RESULT",
					ResultsFormats: []string{"json"},
				},
			},
		},
		WantStatus: []int{0},
	}

	testSampleAzurePipelines := TestCase{
		Name: "should scan a folder with azure-pipelines-vscode files and skip them successfully [E2E-CLI-100]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_100_RESULT", "-v",
					"-p", "\"/path/e2e/fixtures/samples/blacklisted-files/azurepipelinesvscode\"",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "E2E_CLI_100_RESULT",
					ResultsFormats: []string{"json"},
				},
			},
		},
		WantStatus: []int{0},
	}

	testBlacklistedFilesWithExcludeTypeFlag := TestCase{
		Name: "should scan a folder with blacklisted files, with flag --exclude-type, and skip them successfully [E2E-CLI-100]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_100_RESULT", "-v",
					"-p", "\"/path/e2e/fixtures/samples/blacklisted-files\"",
					"--exclude-type", "openapi",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "E2E_CLI_100_RESULT",
					ResultsFormats: []string{"json"},
				},
			},
		},
		WantStatus: []int{0},
	}

	testBlacklistedFilesWithTypeFlag := TestCase{
		Name: "should scan a folder with blacklisted files, with flag --type, and skip them successfully [E2E-CLI-100]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_100_RESULT", "-v",
					"-p", "\"/path/e2e/fixtures/samples/blacklisted-files\"",
					"--type", "azureresourcemanager",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "E2E_CLI_100_RESULT",
					ResultsFormats: []string{"json"},
				},
			},
		},
		WantStatus: []int{0},
	}

	Tests = append(Tests, testSampleFHIR, testSampleAzurePipelines, testBlacklistedFilesWithExcludeTypeFlag, testBlacklistedFilesWithTypeFlag)
}

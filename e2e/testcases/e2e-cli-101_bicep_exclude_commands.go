package testcases

// E2E-CLI-101 - KICS should fail to scan a Bicep file when explicitly included or excluded by type.
// Covers short (-t), long (--type), and exclude (--exclude-type) flags.
// Expected: exit code 126.
func init() { //nolint
	testBicepTypeFlagShort := TestCase{
		Name: "test bicep scan fail with list of platform types to scan, short version [E2E-CLI-101]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output",
					"-p", "\"/path/e2e/fixtures/samples/bicep_sample.bicep\"",
					"-t", "Bicep",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile: "E2E-CLI-101",
				},
			},
		},
		WantStatus: []int{126},
	}

	testBicepTypeFlagLong := TestCase{
		Name: "test bicep scan fail with list of platform types to scan, long version [E2E-CLI-101]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output",
					"-p", "\"/path/e2e/fixtures/samples/bicep_sample.bicep\"",
					"--type", "Bicep",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile: "E2E-CLI-101",
				},
			},
		},
		WantStatus: []int{126},
	}

	testBicepExcludeTypeFlag := TestCase{
		Name: "test bicep scan fail with list of platform types to exclude from scan [E2E-CLI-101]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output",
					"-p", "\"/path/e2e/fixtures/samples/bicep_sample.bicep\"",
					"--exclude-type", "Bicep",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile: "E2E-CLI-101",
				},
			},
		},
		WantStatus: []int{126},
	}

	Tests = append(Tests, testBicepTypeFlagShort, testBicepTypeFlagLong, testBicepExcludeTypeFlag)
}

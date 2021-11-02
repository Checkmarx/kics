package testcases

// E2E-CLI-050 - Kics scan command with --bom (or -m)
// should include bill of materials (BoM) in results output
func init() { //nolint
	testSample := TestCase{
		Name: "should include bill of materials in results output [E2E-CLI-050]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-q", "../assets/queries", "-p", "fixtures/samples/bom-positive.tf",
					"--bom", "-o", "output"},

				[]string{"scan", "-q", "../assets/queries", "-p", "fixtures/samples/bom-positive.tf",
					"--m"},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "results",
					ResultsFormats: []string{"json-bom"},
				},
			},
		},
		WantStatus: []int{50, 126},
	}

	Tests = append(Tests, testSample)
}

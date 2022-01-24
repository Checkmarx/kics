package testcases

// E2E-CLI-053 - Kics scan can ignore entire files, blocks and lines based in kics-ignore comments
func init() { //nolint
	testSample := TestCase{
		Name: "should ignore files/code-blocks/code-lines during the scan [E2E-CLI-053]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-q", "../assets/queries", "-p", "fixtures/samples/scan-ignore/enable.tf"},
				[]string{"scan", "-q", "../assets/queries", "-p", "fixtures/samples/scan-ignore/disable.tf"},
				[]string{"scan", "-q", "../assets/queries", "-p", "fixtures/samples/scan-ignore/ignore-block.dockerfile"},
				[]string{"scan", "-q", "../assets/queries", "-p", "fixtures/samples/scan-ignore/ignore-lines.yaml"},
				[]string{"scan", "-q", "../assets/queries", "-p", "fixtures/samples/scan-ignore/ignore"},
			},
		},
		WantStatus: []int{40, 20, 40, 40, 0},
	}

	Tests = append(Tests, testSample)
}

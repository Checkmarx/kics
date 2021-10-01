package testcases

import "regexp"

// E2E-CLI-014 - KICS preview-lines command must delimit the number of
// code lines that are displayed in each scan results code block.
func init() {
	testSample := TestCase{
		Name: "should modify the default preview-lines value [E2E-CLI-014]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "--preview-lines", "1", "--no-color", "--no-progress",
					"-q", "../assets/queries", "-p", "fixtures/samples/terraform-single.tf"},
			},
		},
		Validation: func(outputText string) bool {
			// only the match1 must be true
			match1, _ := regexp.MatchString(`001\: resource \"aws_redshift_cluster\" \"default1\" \{`, outputText)
			match2, _ := regexp.MatchString(`002\:   publicly_accessible = false`, outputText)
			return match1 && !match2
		},
		WantStatus: []int{40},
	}

	Tests = append(Tests, testSample)
}

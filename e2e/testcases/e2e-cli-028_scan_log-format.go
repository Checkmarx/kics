package testcases

import "regexp"

// E2E-CLI-028 - KICS scan command with --log-format
// should modify the view structure of output messages in the CLI (json/pretty)
func init() { //nolint
	testSample := TestCase{
		Name: "should modify log format messages in the CLI [E2E-CLI-028]",
		Args: args{
			Args: []cmdArgs{

				[]string{"scan", "--log-format", "json", "--verbose",
					"-q", "../assets/queries", "-p", "fixtures/samples/terraform-single.tf"},
			},
		},

		Validation: func(outputText string) bool {
			match1, _ := regexp.MatchString(`{"level":"info"`, outputText)
			match2, _ := regexp.MatchString(`"message":"Inspector initialized, number of queries=\d+"`, outputText)
			return match1 && match2
		},
		WantStatus: []int{40},
	}

	Tests = append(Tests, testSample)
}

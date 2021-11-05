package testcases

import "regexp"

// E2E-CLI-052 - Kics scan with a custom CIS descriptions env variable
// should load and display the correct CIS descriptions (provided by the custom server)
func init() { //nolint
	testSample := TestCase{
		Name: "should load descriptions from a custom server [E2E-CLI-052]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "--queries-path", "../assets/queries",
					"-p", "fixtures/samples/terraform.tf", "--no-color"},
			},
		},
		Validation: func(outputText string) bool {
			match1, _ := regexp.MatchString("Test 1A", outputText)
			return match1
		},
		WantStatus: []int{50, 0, 0, 126},
	}

	Tests = append(Tests, testSample)
}

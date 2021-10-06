package testcases

import "regexp"

// E2E-CLI-046 - Kics scan command with --disable-full-descriptions
// should fetch CIS descriptions from environment URL KICS_DESCRIPTIONS_ENDPOINT.
func init() { //nolint
	testSample := TestCase{
		Name: "should fetch CIS descriptions from environment [E2E-CLI-046]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-q", "../assets/queries", "-p", "fixtures/samples/terraform.tf",
					"--no-color", "-v",
					"--disable-full-descriptions"},
			},
		},
		Validation: func(outputText string) bool {
			uuidRegex := "Skipping CIS descriptions because provided disable flag is set"
			match, _ := regexp.MatchString(uuidRegex, outputText)
			return match
		},
		WantStatus: []int{50},
	}

	Tests = append(Tests, testSample)
}

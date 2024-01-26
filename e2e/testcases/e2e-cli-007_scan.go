package testcases

import "regexp"

// E2E-CLI-007 - the default kics scan must show informations such as 'Files scanned',
// 'Queries loaded', 'Scan Duration', '...' in the CLI
func init() { //nolint
	testSample := TestCase{
		Name: "should perform a simple scan [E2E-CLI-007]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-p", "/path/e2e/fixtures/samples/positive.yaml", "-v"},
			},
		},
		WantStatus: []int{50},
		Validation: func(outputText string) bool {
			match1, _ := regexp.MatchString(`Scanned Files: \d+`, outputText)
			match2, _ := regexp.MatchString(`Parsed Files: \d+`, outputText)
			match3, _ := regexp.MatchString(`Queries loaded: \d+`, outputText)
			match4, _ := regexp.MatchString(`Queries failed to execute: \d+`, outputText)
			match5, _ := regexp.MatchString(`Results Summary:`, outputText)
			match6, _ := regexp.MatchString(`Scan duration: \d+(m\d+)?(.\d+)?s`, outputText)
			return match1 && match2 && match3 && match4 && match5 && match6
		},
	}

	Tests = append(Tests, testSample)
}

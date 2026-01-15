package testcases

import "regexp"

// E2E-CLI-014 - KICS preview-lines command must delimit the number of
// code lines that are displayed in each scan results code block.
func init() { //nolint
	testSample := TestCase{
		Name: "should modify the default preview-lines value [E2E-CLI-014]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "--preview-lines", "1", "--no-color", "--no-progress",
					"-p", "/path/e2e/fixtures/samples/positive.dockerfile"},
			},
		},
		Validation: func(outputText string) bool {
			// only the match1 must be true
			match1, _ := regexp.MatchString(`005\: RUN gem install grpc -v \$\{GRPC_RUBY_VERSION\} blunder`, outputText)
			match2, _ := regexp.MatchString(`006\: RUN bundle install`, outputText)
			return match1 && !match2
		},
		WantStatus: []int{50},
	}

	Tests = append(Tests, testSample)
}

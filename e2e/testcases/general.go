package testcases

type TestCase struct {
	Name       string
	Args       args
	WantStatus []int
	Validation Validation
}

type LogValidation struct {
	LogFile        string
	ValidationFunc Validation
}

type Validation func(string) bool

type ResultsValidation struct {
	ResultsFile    string
	ResultsFormats []string
}

type args struct {
	Args            []cmdArgs // args to pass to kics binary
	ExpectedOut     []string  // path to file with expected output
	ExpectedPayload []string
	ExpectedResult  []ResultsValidation
	ExpectedLog     LogValidation
	UseMock         []bool
}

type TestTemplates struct {
	Help     string
	ScanHelp string
}

type cmdArgs []string

var Tests = make([]TestCase, 0)

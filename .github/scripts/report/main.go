package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"math"
	"os"
	"path/filepath"
	"regexp"
	"sort"
	"strings"
)

type ReportData struct {
	Result    TestLog
	TestsData []TestsData
	Counters  Counters
}

type Counters struct {
	CountPass  int
	CountFail  int
	CountTotal int
}

type ExpectedActual struct {
	ExtraElements ActualExpectedWithStatus // list of extra elements
	TestInfo      []string
	Messages      ActualExpectedWithStatus
	FailOutput    []string
}

type ActualExpectedWithStatus struct {
	ExpectedContent []CodeLineStatus
	ActualContent   []CodeLineStatus
}

type CodeLineStatus struct {
	Line   string
	Status bool // differed or not
}

type TestsData struct {
	TestLog        TestLog
	ExpectedActual ExpectedActual
	FailLog        []string
}

type TestLog struct {
	Time    string  `json:"Time"`
	Action  string  `json:"Action"`
	Package string  `json:"Package"`
	Test    string  `json:"Test"`
	Output  string  `json:"Output"`
	Elapsed float64 `json:"Elapsed"`
}

type TestFail struct {
	Test   string `json:"Test"`
	Output string `json:"Output"`
}

const (
	prefixActualPayload      = "actualPayload"
	prefixExpectedPayload    = "expectedPayload"
	prefixFail               = "--- FAIL:"
	prefixQueries            = `"queries": [`
	extraElementsListA       = "extra elements in list A:"
	extraElementsListB       = "extra elements in list B:"
	prefixTest               = "Test:"
	suffixExpectedQueries    = "Expected Queries content: 'fixtures/{"
	suffixActualQueries      = "doesn't match the Actual Queries content: 'output/{"
	prefixTypeInterface      = "([]interface {})"
	prefixTypeVulnerableFile = "(model.VulnerableFile) {"
	expectedNumberOflines    = "Expected file number of lines:"
	actualNumberOfLines      = "Actual file number of lines:"
	severityCountersMarker   = "Expected Severity Counters content:"
)

func FindTest(tests []TestsData, testName string) (*TestsData, bool) {
	for i := range tests {
		if tests[i].TestLog.Test == testName {
			return &tests[i], true
		}
	}
	return nil, false
}

func cleanOutput(s string) string {
	// remove (len=N)
	lenPattern := regexp.MustCompile(`\(len=\d+\)\s*`)
	s = lenPattern.ReplaceAllString(s, "")
	// Remove type annotations like (string), (int), (*string), (model.IssueType)...
	typePattern := regexp.MustCompile(`\([a-zA-Z*\[][^)]*\)\s*`)
	s = typePattern.ReplaceAllString(s, "")
	return s
}

func stripCommonLeadingWhitespace(lines []CodeLineStatus) []CodeLineStatus {
	if len(lines) == 0 {
		return lines
	}
	prefixLen := -1
	for _, cls := range lines {
		trimmed := strings.TrimRight(cls.Line, "\n\r")
		if strings.TrimSpace(trimmed) == "" {
			continue
		}
		count := 0
		for count < len(trimmed) && (trimmed[count] == ' ' || trimmed[count] == '\t') {
			count++
		}
		if prefixLen == -1 || count < prefixLen {
			prefixLen = count
		}
	}
	if prefixLen <= 0 {
		return lines
	}
	result := make([]CodeLineStatus, len(lines))
	for i, cls := range lines {
		line := cls.Line
		if len(line) >= prefixLen {
			line = line[prefixLen:]
		}
		result[i] = CodeLineStatus{Line: line, Status: cls.Status}
	}
	return result
}

func extractPayloadDiffLines(failLog []string) ExpectedActual {
	var testInfo []string
	var messages ActualExpectedWithStatus
	var failOutput []string

	const (
		stateNone = iota
		stateMessagesExpected
		stateMessagesActual
		stateTestInfo
		stateFailLog
	)
	state := stateTestInfo

	for _, line := range failLog {
		trimmed := strings.TrimSpace(line)
		if strings.HasPrefix(trimmed, prefixActualPayload) {
			state = stateMessagesActual
		} else if strings.HasPrefix(trimmed, prefixExpectedPayload) {
			state = stateMessagesExpected
		} else if strings.HasPrefix(trimmed, prefixFail) {
			state = stateFailLog
		} else if strings.HasPrefix(trimmed, prefixQueries) {
			state = stateNone
		}

		switch state {
		case stateMessagesActual:
			if !strings.HasPrefix(trimmed, prefixActualPayload) {
				messages.ActualContent = append(messages.ActualContent, CodeLineStatus{
					Line:   line,
					Status: false,
				})
			}
		case stateMessagesExpected:
			if !strings.HasPrefix(trimmed, prefixExpectedPayload) {
				messages.ExpectedContent = append(messages.ExpectedContent, CodeLineStatus{
					Line:   line,
					Status: false,
				})
			}
		case stateFailLog:
			failOutput = append(failOutput, line)
			state = stateNone
		case stateTestInfo:
			testInfo = append(testInfo, line)
		}
	}
	return ExpectedActual{
		TestInfo:   testInfo,
		Messages:   messages,
		FailOutput: failOutput,
	}
}

func isExtraElementsContentLine(trimmed string) bool {
	ret := !strings.HasPrefix(trimmed, prefixTypeInterface) && !strings.HasPrefix(trimmed, prefixTypeVulnerableFile)
	return ret
}

func extractExpectedActualLines(failLog []string) ExpectedActual {
	var extraElements ActualExpectedWithStatus
	var testInfo []string
	var messages ActualExpectedWithStatus
	var failOutput []string

	const (
		stateNone = iota
		stateExtraA
		stateExtraB
		stateTestInfo
		stateMessagesExpected
		stateMessagesActual
		stateFailLog
	)
	state := stateNone

	for _, line := range failLog {
		trimmed := strings.TrimSpace(line)
		switch trimmed {
		case extraElementsListA:
			state = stateExtraA
			continue
		case extraElementsListB:
			state = stateExtraB
			continue
		}
		if strings.HasPrefix(trimmed, prefixTest) {
			state = stateTestInfo
		} else if strings.HasSuffix(trimmed, suffixExpectedQueries) {
			state = stateMessagesExpected
		} else if strings.HasSuffix(trimmed, suffixActualQueries) {
			state = stateMessagesActual
		} else if strings.HasPrefix(trimmed, prefixFail) {
			state = stateFailLog
		}
		if trimmed == "" && (state == stateExtraA || state == stateExtraB) {
			state = stateNone
			continue
		}

		switch state {
		case stateExtraA:
			if isExtraElementsContentLine(trimmed) {
				cleanedLine := cleanOutput(line)
				extraElements.ExpectedContent = append(extraElements.ExpectedContent, CodeLineStatus{
					Line:   cleanedLine,
					Status: false,
				})
			}
		case stateExtraB:
			if isExtraElementsContentLine(trimmed) {
				cleanedLine := cleanOutput(line)
				extraElements.ActualContent = append(extraElements.ActualContent, CodeLineStatus{
					Line:   cleanedLine,
					Status: false,
				})
			}
		case stateTestInfo:
			testInfo = append(testInfo, line)
		case stateMessagesActual:
			if !strings.HasSuffix(trimmed, suffixActualQueries) {
				messages.ActualContent = append(messages.ActualContent, CodeLineStatus{
					Line:   line,
					Status: false,
				})
			}
		case stateMessagesExpected:
			if !strings.HasSuffix(trimmed, suffixExpectedQueries) {
				messages.ExpectedContent = append(messages.ExpectedContent, CodeLineStatus{
					Line:   line,
					Status: false,
				})
			}
		case stateFailLog:
			failOutput = append(failOutput, line)
			state = stateNone
		}
	}

	extraElements.ExpectedContent = stripCommonLeadingWhitespace(extraElements.ExpectedContent)
	extraElements.ActualContent = stripCommonLeadingWhitespace(extraElements.ActualContent)

	return ExpectedActual{
		ExtraElements: extraElements,
		TestInfo:      testInfo,
		Messages:      messages,
		FailOutput:    failOutput,
	}
}

func isSeverityCountersDiff(failLog []string) bool {
	for _, line := range failLog {
		if strings.Contains(line, severityCountersMarker) {
			return true
		}
	}
	return false
}

func parseSeverityMap(mapStr string) []CodeLineStatus {
	inner := strings.TrimPrefix(mapStr, "map[")
	inner = strings.TrimSuffix(inner, "]")
	re := regexp.MustCompile(`(\w+):%!s\(int=(\d+)\)`)
	matches := re.FindAllStringSubmatch(inner, -1)
	var lines []CodeLineStatus
	for _, m := range matches {
		lines = append(lines, CodeLineStatus{
			Line:   fmt.Sprintf("%s: %s", m[1], m[2]),
			Status: false,
		})
	}
	return lines
}

func extractSeverityCounterLines(failLog []string) ExpectedActual {
	var testInfo []string
	var messages ActualExpectedWithStatus
	var failOutput []string

	for _, line := range failLog {
		trimmed := strings.TrimSpace(line)
		if strings.Contains(trimmed, severityCountersMarker) {
			expectedMapRe := regexp.MustCompile(`fixtures/(map\[[^\]]+\])`)
			actualMapRe := regexp.MustCompile(`output/(map\[[^\]]+\])`)
			if em := expectedMapRe.FindStringSubmatch(trimmed); em != nil {
				messages.ExpectedContent = parseSeverityMap(em[1])
			}
			if am := actualMapRe.FindStringSubmatch(trimmed); am != nil {
				messages.ActualContent = parseSeverityMap(am[1])
			}
		} else if strings.HasPrefix(trimmed, prefixFail) {
			failOutput = append(failOutput, line)
		} else {
			testInfo = append(testInfo, line)
		}
	}

	return ExpectedActual{
		TestInfo:   testInfo,
		Messages:   messages,
		FailOutput: failOutput,
	}
}

func isDifferentNumberOfLines(failLog []string) bool {
	var hasExpectedFileNumberLines, hasActualFileNumberLines bool
	for _, failLogEntry := range failLog {
		trimmedEntry := strings.TrimSpace(failLogEntry)
		if trimmedEntry == "" {
			continue
		}
		if strings.Contains(trimmedEntry, expectedNumberOflines) {
			hasExpectedFileNumberLines = true
		}
		if strings.Contains(failLogEntry, actualNumberOfLines) {
			hasActualFileNumberLines = true
		}
		if hasExpectedFileNumberLines && hasActualFileNumberLines {
			return true
		}
	}
	return false
}

func isExpectedVsActual(failLog []string) bool {
	var hasExtraA, hasExtraB bool
	for _, failLogEntry := range failLog {
		trimmedEntry := strings.TrimSpace(failLogEntry)
		if trimmedEntry == extraElementsListA {
			hasExtraA = true
		}
		if trimmedEntry == extraElementsListB {
			hasExtraB = true
		}
		if hasExtraA && hasExtraB {
			return true
		}
	}
	return false
}

func compareMessageContent(expectedActual *ExpectedActual) {
	expectedLen := len(expectedActual.Messages.ExpectedContent)
	actualLen := len(expectedActual.Messages.ActualContent)
	actualLenExtraElements := len(expectedActual.ExtraElements.ExpectedContent)
	expectedLenExtraElements := len(expectedActual.ExtraElements.ActualContent)

	maxLen := expectedLen
	if actualLen > maxLen {
		maxLen = actualLen
	}
	maxLenExtraElements := expectedLenExtraElements
	if actualLenExtraElements > maxLenExtraElements {
		maxLenExtraElements = actualLenExtraElements
	}

	for i := range maxLen {
		// if one side has no line at this index, the line is marked as different
		if i >= expectedLen || i >= actualLen {
			if i < expectedLen {
				expectedActual.Messages.ExpectedContent[i].Status = true
			}
			if i < actualLen {
				expectedActual.Messages.ActualContent[i].Status = true
			}
			continue
		}
		expectedContentLine := strings.TrimSpace(expectedActual.Messages.ExpectedContent[i].Line)
		actualContentLine := strings.TrimSpace(expectedActual.Messages.ActualContent[i].Line)
		if expectedContentLine != actualContentLine {
			expectedActual.Messages.ExpectedContent[i].Status = true
			expectedActual.Messages.ActualContent[i].Status = true
		}
	}

	for j := range maxLenExtraElements {
		if j >= expectedLenExtraElements || j >= actualLenExtraElements {
			if j < expectedLenExtraElements {
				expectedActual.ExtraElements.ExpectedContent[j].Status = true
			}
			if j < actualLenExtraElements {
				expectedActual.ExtraElements.ActualContent[j].Status = true
			}
			continue
		}
		expectedContentLine := strings.TrimSpace(expectedActual.ExtraElements.ExpectedContent[j].Line)
		actualContentLine := strings.TrimSpace(expectedActual.ExtraElements.ActualContent[j].Line)
		if expectedContentLine != actualContentLine {
			expectedActual.ExtraElements.ExpectedContent[j].Status = true
			expectedActual.ExtraElements.ActualContent[j].Status = true
		}
	}
}

func main() {
	fmt.Printf("Started report script\n")
	var testPath, testName, reportPath, reportName string

	fmt.Printf("Report generator\n")

	flag.StringVar(&testPath, "test-path", "", "")
	flag.StringVar(&testName, "test-name", "", "")
	flag.StringVar(&reportPath, "report-path", "", "")
	flag.StringVar(&reportName, "report-name", "", "")

	flag.Parse()

	// Read TestLog (NDJSON)
	jsonTestsOutput, err := os.Open(filepath.Clean(filepath.Join(filepath.ToSlash(testPath), testName)))
	if err != nil {
		fmt.Printf("Error when trying to open: %v\n", filepath.Join(filepath.ToSlash(testPath), testName))
		os.Exit(1)
	}

	decoder := json.NewDecoder(jsonTestsOutput)

	testList := []TestsData{}
	finalStatus := TestLog{}

	// Parse Tests Status
	hasFailures := false

	fmt.Printf("Parsing tests data...\n")

	for decoder.More() {
		var log TestLog

		err := decoder.Decode(&log)
		if err != nil {
			fmt.Printf("Error when trying to decode: %v\n", err)
			fmt.Printf("Verify if the JSON File has UTF8 encoding")
		}
		if log.Action == "pass" || log.Action == "fail" {
			if log.Test == "" {
				finalStatus = log
				finalStatus.Elapsed = math.Ceil(finalStatus.Elapsed*100) / 100
			} else if log.Test != "Test_E2E_CLI" {
				if log.Action == "fail" {
					hasFailures = true
				}
				test, exists := FindTest(testList, log.Test)
				if exists {
					if log.Action == "fail" {
						test.TestLog = log
					}
				} else {
					testList = append(testList, TestsData{TestLog: log, FailLog: nil})
				}
			}
		}
	}

	// Parse Output from Failed Tests
	if hasFailures {
		jsonTestsOutputClean, err := os.Open(filepath.Clean(filepath.Join(filepath.ToSlash(testPath), testName)))
		if err != nil {
			fmt.Printf("Error when trying to open: %v\n", filepath.Join(filepath.ToSlash(testPath), testName))
			os.Exit(1)
		}
		decoder2 := json.NewDecoder(jsonTestsOutputClean)
		for decoder2.More() {
			var log TestLog
			errDecoder := decoder2.Decode(&log)
			if errDecoder != nil {
				fmt.Printf("Error when decoding: %w\n", log)
				os.Exit(1)
			}

			if log.Action != "output" {
				continue
			}

			test, exists := FindTest(testList, log.Test)
			if !exists || test.TestLog.Action != "fail" {
				continue
			}
			test.FailLog = append(test.FailLog, log.Output)
		}

		for i := range testList {
			test := &testList[i]
			if test.TestLog.Action != "fail" {
				continue
			}

			if isExpectedVsActual(test.FailLog) {
				expectedActual := extractExpectedActualLines(test.FailLog)
				compareMessageContent(&expectedActual)
				test.ExpectedActual = expectedActual
			} else if isSeverityCountersDiff(test.FailLog) {
				expectedActual := extractSeverityCounterLines(test.FailLog)
				compareMessageContent(&expectedActual)
				test.ExpectedActual = expectedActual
			} else if isDifferentNumberOfLines(test.FailLog) {
				expectedActual := extractPayloadDiffLines(test.FailLog)
				compareMessageContent(&expectedActual)
				test.ExpectedActual = expectedActual
			}
		}
	}

	fmt.Printf("Parsing tests data... Done!\n")
	fmt.Printf("Creating report...\n")

	// Format & Sort Tests
	counter := Counters{
		CountPass:  0,
		CountFail:  0,
		CountTotal: 0,
	}

	for index, test := range testList {
		testList[index].TestLog.Test = strings.ReplaceAll(test.TestLog.Test, "Test_E2E_CLI/", "")
		if test.TestLog.Action == "pass" {
			counter.CountPass += 1
		} else {
			counter.CountFail += 1
		}
	}

	counter.CountTotal = counter.CountFail + counter.CountPass

	sort.Slice(testList, func(i, j int) bool {
		return testList[i].TestLog.Test < testList[j].TestLog.Test
	})

	reportList := ReportData{
		TestsData: testList,
		Result:    finalStatus,
		Counters:  counter,
	}

	reportError := generateE2EReport(filepath.ToSlash(reportPath), reportName, reportList)
	if reportError != nil {
		fmt.Println(reportError)
		os.Exit(1)
	}

	fmt.Printf("Creating report... Done!\n")
	fmt.Printf("Finished!\n")
}

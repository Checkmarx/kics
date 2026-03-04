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
	ExtraElements         ActualExpectedWithStatus // list of extra elements
	TestInfo              []string
	Messages 			  ActualExpectedWithStatus
	FailOutput            []string
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
	TestLog TestLog
	ExpectedActual ExpectedActual
	FailLog []string
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
		if strings.HasPrefix(trimmed, "actualPayload") {
			state = stateMessagesActual
		} else if strings.HasPrefix(trimmed, "expectedPayload") {
			state = stateMessagesExpected
		} else if strings.HasPrefix(trimmed, "--- FAIL:") {
			state = stateFailLog
		} else if strings.HasPrefix(trimmed, `"queries": [`) {
			state = stateNone
		}

		switch state {
		case stateMessagesActual:
			if !strings.HasPrefix(trimmed, "actualPayload") {
				messages.ActualContent = append(messages.ActualContent, CodeLineStatus{
					Line: line,
					Status: false,
				})
			}
		case stateMessagesExpected:
			if !strings.HasPrefix(trimmed, "expectedPayload") {
				messages.ExpectedContent = append(messages.ExpectedContent, CodeLineStatus{
					Line: line,
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
		TestInfo: testInfo,
		Messages: messages,
		FailOutput: failOutput,
	}
}

func extractExpectedActualLines(failLog []string) ExpectedActual {
	var extraElements ActualExpectedWithStatus
	//var extraExpected []string // extra elements in list A
	//var extraActual []string
	var testInfo []string
	var messages ActualExpectedWithStatus
	var failOutput []string

	const (
		stateNone         = iota
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
		case "extra elements in list A:":
			state = stateExtraA
			continue
		case "extra elements in list B:":
			state = stateExtraB
			continue
		}

		if strings.HasPrefix(trimmed, "Test:") {
			state = stateTestInfo
		} else if strings.HasSuffix(trimmed, "Expected Queries content: 'fixtures/{") {
			state = stateMessagesExpected
		} else if strings.HasSuffix(trimmed, "doesn't match the Actual Queries content: 'output/{") {
			state = stateMessagesActual
		} else if strings.HasPrefix(trimmed, "--- FAIL:") {
			state = stateFailLog
		}

		if trimmed == "" && (state == stateExtraA || state == stateExtraB) {
			state = stateNone
			continue
		}

		switch state {
		case stateExtraA:
			if !strings.HasPrefix(trimmed, "([]interface {})") && !strings.HasPrefix(trimmed, "(model.VulnerableFile) {") {
				cleaned_extraElement_line := cleanOutput(line)
				extraElements.ExpectedContent = append(extraElements.ExpectedContent, CodeLineStatus{
					Line: cleaned_extraElement_line,
					Status: false,
				})
			}
		case stateExtraB:
			if !strings.HasPrefix(trimmed, "([]interface {})") && !strings.HasPrefix(trimmed, "(model.VulnerableFile) {") {
				cleaned_extraElement_line := cleanOutput(line)
				extraElements.ActualContent = append(extraElements.ActualContent, CodeLineStatus{
					Line: cleaned_extraElement_line,
					Status: false,
				})
			}
		case stateTestInfo:
			testInfo = append(testInfo, line)
		case stateMessagesActual:
			if !strings.HasSuffix(trimmed, "doesn't match the Actual Queries content: 'output/{") {
				messages.ActualContent = append(messages.ActualContent, CodeLineStatus{
					Line: line,
					Status: false,
				})
			}
		case stateMessagesExpected:
			if !strings.HasSuffix(trimmed, "Expected Queries content: 'fixtures/{") {
				messages.ExpectedContent = append(messages.ExpectedContent, CodeLineStatus{
					Line: line, 
					Status: false,
				})
			}
		case stateFailLog:
			failOutput = append(failOutput, line)
			state = stateNone
		}
	}

	return ExpectedActual{
		ExtraElements: extraElements,
		TestInfo: testInfo,
		Messages: messages,
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
		if strings.Contains(trimmedEntry, "Expected file number of lines:") {
			hasExpectedFileNumberLines = true
		}
		if strings.Contains(failLogEntry, "Actual file number of lines:") {
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
		if trimmedEntry == "extra elements in list A:" {
			hasExtraA = true
		}
		if trimmedEntry == "extra elements in list B:" {
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
		// if one of the sides does not have a line in this position, the one that exists 
		// is tagged as the different one
		if i >= expectedLen || i >= actualLen {
			if i < expectedLen {
				expectedActual.Messages.ExpectedContent[i].Status = true
			}
			if i < actualLen {
				expectedActual.Messages.ActualContent[i].Status = true
			}
			continue
		}
		if expectedActual.Messages.ExpectedContent[i].Line != expectedActual.Messages.ActualContent[i].Line {
			expectedActual.Messages.ExpectedContent[i].Status = true
			expectedActual.Messages.ActualContent[i].Status = true
		}
	}

	for j := range maxLenExtraElements {
		if j >= expectedLenExtraElements || j >= actualLenExtraElements {
			if j < expectedLenExtraElements {
				expectedActual.ExtraElements.ExpectedContent[j].Status = true
			}
			if j > actualLenExtraElements {
				expectedActual.ExtraElements.ActualContent[j].Status = true
			}
			continue
		}
		if expectedActual.ExtraElements.ExpectedContent[j].Line != expectedActual.ExtraElements.ActualContent[j].Line {
			expectedActual.ExtraElements.ExpectedContent[j].Status = true
			expectedActual.ExtraElements.ActualContent[j].Status = true
		}
	}
}

func main() {
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
			test.FailLog = append(test.FailLog, log.Output) // dá append do log.Output no test.FailLog que é uma linha do erro de cada vez
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

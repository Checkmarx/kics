package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"math"
	"os"
	"path/filepath"
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
	ExtraElementsExpected []string // changed elements in list A (expected)
	ExtraElementsActual   []string // changed elements in list B (actual)
	FullExpected          []string // entire expected result (list A)
	FullActual 			  []string // entire actual result (list B)
	TestInfo              []string
	Messages 			  MessageActualExpected
	FailOutput            []string
}

type MessageActualExpected struct {
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

func extractExpectedActualLines(failLog []string) (ExpectedActual) {
	var extraExpected []string // extra elements in list A
	var extraActual []string
	var fullExpected []string
	var fullActual []string
	var testInfo []string
	var messages MessageActualExpected

	const (
		stateNone         = iota
		stateExtraA
		stateExtraB
		stateListA
		stateListB
		stateTestInfo
		stateMessagesExpected
		stateMessagesActual
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
		case "listA:":
			state = stateListA
			continue
		case "listB:":
			state = stateListB
			continue
		}

		if strings.HasPrefix(trimmed, "Test:") {
			state = stateTestInfo
		} else if strings.HasSuffix(trimmed, "Expected Queries content: 'fixtures/{") {
			state = stateMessagesExpected
		} else if strings.HasSuffix(trimmed, "doesn't match the Actual Queries content: 'output/{") {
			state = stateMessagesActual
		} else if strings.HasPrefix(trimmed, "--- FAIL:") {
			state = stateNone
		}

		if trimmed == "" && (state == stateExtraA || state == stateExtraB) {
			state = stateNone
			continue
		}

		switch state {
		case stateExtraA:
			extraExpected = append(extraExpected, line)
		case stateExtraB:
			extraActual = append(extraActual, line)
		case stateListA:
			fullExpected = append(fullExpected, line)
		case stateListB:
			fullActual = append(fullActual, line)
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
		}
	}

	return ExpectedActual{
		ExtraElementsExpected: extraExpected,
		ExtraElementsActual: extraActual,
		FullExpected: fullExpected,
		FullActual: fullActual,
		TestInfo: testInfo,
		Messages: messages,
	}
}

func isExpectedVsActual(failLog []string) bool {
	fmt.Printf("inside isExpectedVsAtual() with the following failLog:\n")

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
			fmt.Printf("isExpectedvsActual is returning true\n")
			return true
		}
	}
	fmt.Printf("isExpectedvsActual is returning false\n")
	return false
}

func compareMessageContent(expectedActual *ExpectedActual) {
	expectedLen := len(expectedActual.Messages.ExpectedContent)
	actualLen := len(expectedActual.Messages.ActualContent)

	maxLen := expectedLen
    if actualLen > maxLen {
        maxLen = actualLen
    }

	for i := range int(maxLen) {
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
			fmt.Printf("[4] log content: %+v\n", log)
			//fmt.Printf("[2] log.Action == \"pass\" || log.Action == \"fail\"\n")
			if log.Test == "" {
				finalStatus = log
				finalStatus.Elapsed = math.Ceil(finalStatus.Elapsed*100) / 100
			} else if log.Test != "Test_E2E_CLI" {
				fmt.Printf("[5] log.Test != \"Test_E2E_CLI\" -> %v \n", log.Test)
				if log.Action == "fail" {
					hasFailures = true
				}
				test, exists := FindTest(testList, log.Test)
				fmt.Printf("[7] FindTest returned: | %v | %v |\n", test, exists)
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
		fmt.Printf("Opening file with the path: %v\n", filepath.Clean(filepath.Join(filepath.ToSlash(testPath), testName)))
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
			}
		}
		
		for i, test := range testList {
			fmt.Printf("testList[%d]:\n", i)
			for j, entry := range test.ExpectedActual.ExtraElementsActual {
				fmt.Printf("    ExpectedActual.ExtraElementsActual[%d]: %v\n", j, entry)
			}
			for k, entry_2 := range test.ExpectedActual.ExtraElementsExpected {
				fmt.Printf("    ExpectedActual.ExtraElementsExpected[%d]: %v\n", k, entry_2)
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

	//fmt.Printf("--10-- After appending the log.Output on the test.FailLog the remaining test structure is the following one:\n")
	//fmt.Printf("_________________________________________\n%+v\n______________________________________________________________\n", testList)

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

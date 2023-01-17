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

type TestsData struct {
	TestLog TestLog
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

			test.FailLog = append(test.FailLog, log.Output)
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

package model

import (
	"encoding/xml"
	"fmt"

	"github.com/Checkmarx/kics/internal/constants"
	"github.com/Checkmarx/kics/pkg/model"
)

type testSuites struct {
	XMLName    xml.Name    `xml:"testsuites"`
	Name       string      `xml:"name,attr"`
	Time       string      `xml:"time,attr"`
	Failures   string      `xml:"failures,attr"`
	TestSuites []testSuite `xml:"testsuite"`
}

type testSuite struct {
	XMLName   xml.Name   `xml:"testsuite"`
	Name      string     `xml:"name,attr"`
	Failures  string     `xml:"failures,attr"`
	Tests     string     `xml:"tests,attr"`
	TestCases []testCase `xml:"testcase"`
	failCount int
}

type testCase struct {
	XMLName  xml.Name  `xml:"testcase"`
	Name     string    `xml:"name,attr"`
	Failures []failure `xml:"failure"`
}

type failure struct {
	XMLName xml.Name `xml:"failure"`
	Type    string   `xml:"type,attr"`    // Query name
	Message string   `xml:"message,attr"` // File name + line number
}

// JUnitReport is a JUnit report representation
type JUnitReport interface {
	GenerateTestEntry(query *model.QueryResult)
	FinishReport()
}

// NewJUnitReport creates a new JUnit report instance
func NewJUnitReport(time string) JUnitReport {
	return &testSuites{
		Name:       fmt.Sprintf("KICS v%s", constants.Version),
		Time:       time,
		Failures:   "",
		TestSuites: make([]testSuite, 0),
	}
}

// GenerateTestEntry generates a new test entry for failed tests on KICS scan
func (jUnit *testSuites) GenerateTestEntry(query *model.QueryResult) {
	queryDescription := query.Description
	if query.CISDescriptionText != "" {
		queryDescription = query.CISDescriptionText
	}
	failedTestCase := testCase{
		Name:     queryDescription,
		Failures: make([]failure, len(query.Files)),
	}

	for idx := range query.Files {
		failedTest := failure{
			Type:    query.QueryName,
			Message: fmt.Sprintf("%s:%d", query.Files[idx].FileName, query.Files[idx].Line),
		}
		failedTestCase.Failures[idx] = failedTest
	}
	for idx := range jUnit.TestSuites {
		if jUnit.TestSuites[idx].Name == query.Platform {
			jUnit.TestSuites[idx].TestCases = append(jUnit.TestSuites[idx].TestCases, failedTestCase)
			jUnit.TestSuites[idx].failCount += len(query.Files)
			return
		}
	}
	newTestSuite := testSuite{
		Name:      query.Platform,
		Failures:  "",
		Tests:     "",
		failCount: len(query.Files),
		TestCases: make([]testCase, 0),
	}
	newTestSuite.TestCases = append(newTestSuite.TestCases, failedTestCase)
	jUnit.TestSuites = append(jUnit.TestSuites, newTestSuite)
}

// FinishReport finishes the report, adding the total number of failed tests for each platform and the total number of failed tests
func (jUnit *testSuites) FinishReport() {
	failsCount := 0
	for idx := range jUnit.TestSuites {
		failsCount += jUnit.TestSuites[idx].failCount
		jUnit.TestSuites[idx].Failures = fmt.Sprintf("%d", jUnit.TestSuites[idx].failCount)
		jUnit.TestSuites[idx].Tests = fmt.Sprintf("%d", jUnit.TestSuites[idx].failCount)
	}
	jUnit.Failures = fmt.Sprintf("%d", failsCount)
}

package model

import (
	"encoding/xml"
	"fmt"
	"strings"

	"github.com/Checkmarx/kics/v2/internal/constants"
	"github.com/Checkmarx/kics/v2/pkg/model"
)

type junitTestSuites struct {
	XMLName    xml.Name         `xml:"testsuites"`
	Name       string           `xml:"name,attr"`
	Time       string           `xml:"time,attr"`
	Failures   string           `xml:"failures,attr"`
	TestSuites []junitTestSuite `xml:"testsuite"`
}

type junitTestSuite struct {
	XMLName   xml.Name        `xml:"testsuite"`
	Name      string          `xml:"name,attr"`
	Failures  string          `xml:"failures,attr"`
	Tests     string          `xml:"tests,attr"`
	TestCases []junitTestCase `xml:"testcase"`
	failCount int
}

type junitTestCase struct {
	XMLName   xml.Name       `xml:"testcase"`
	CWE       string         `xml:"cwe,attr,omitempty"`
	Name      string         `xml:"name,attr"`
	ClassName string         `xml:"classname,attr"`
	Failures  []junitFailure `xml:"failure"`
}

type junitFailure struct {
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
	return &junitTestSuites{
		Name:       fmt.Sprintf("KICS %s", constants.Version),
		Time:       time,
		Failures:   "",
		TestSuites: []junitTestSuite{},
	}
}

// GenerateTestEntry generates a new test entry for failed tests on KICS scan
func (jUnit *junitTestSuites) GenerateTestEntry(query *model.QueryResult) {
	queryDescription := query.Description
	if query.CISDescriptionTextFormatted != "" {
		queryDescription = query.CISDescriptionTextFormatted
	}

	failedTestCases := []junitTestCase{}

	for idx := range query.Files {
		failedTestCase := junitTestCase{
			Name:      fmt.Sprintf("%s: %s file in line %d", query.QueryName, query.Files[idx].FileName, query.Files[idx].Line),
			ClassName: query.Platform,
			CWE:       query.CWE,
			Failures:  []junitFailure{},
		}

		failedTest := junitFailure{
			Type: queryDescription,
			Message: fmt.Sprintf(
				"[Severity: %s, Query description: %s] Problem found on '%s' file in line %d. Expected value: %s. Actual value: %s.",
				query.Severity,
				queryDescription,
				query.Files[idx].FileName,
				query.Files[idx].Line,
				strings.TrimRight(query.Files[idx].KeyExpectedValue, "."),
				strings.TrimRight(query.Files[idx].KeyActualValue, "."),
			),
		}

		failedTestCase.Failures = append(failedTestCase.Failures, failedTest)
		failedTestCases = append(failedTestCases, failedTestCase)
	}

	newTestSuite := junitTestSuite{
		Name:      query.Platform,
		Failures:  "",
		Tests:     "",
		failCount: len(query.Files),
		TestCases: failedTestCases,
	}

	jUnit.TestSuites = append(jUnit.TestSuites, newTestSuite)
}

// FinishReport finishes the report, adding the total number of failed tests for each platform and the total number of failed tests
func (jUnit *junitTestSuites) FinishReport() {
	failsCount := 0
	for idx := range jUnit.TestSuites {
		failsCount += jUnit.TestSuites[idx].failCount
		jUnit.TestSuites[idx].Failures = fmt.Sprintf("%d", jUnit.TestSuites[idx].failCount)
		jUnit.TestSuites[idx].Tests = fmt.Sprintf("%d", jUnit.TestSuites[idx].failCount)
	}
	jUnit.Failures = fmt.Sprintf("%d", failsCount)
}

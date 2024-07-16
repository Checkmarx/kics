package model

import (
	"encoding/xml"
	"fmt"
	"testing"

	"github.com/Checkmarx/kics/v2/internal/constants"
	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/stretchr/testify/require"
	"helm.sh/helm/v3/pkg/time"
)

var now = time.Now().String()

func TestNewJUnitReport(t *testing.T) {
	now := time.Now().String()
	got := NewJUnitReport(now).(*junitTestSuites)
	require.Equal(t, now, got.Time)
	require.Equal(t, fmt.Sprintf("KICS %s", constants.Version), got.Name)
	require.Equal(t, "", got.Failures)
	require.Len(t, got.TestSuites, 0)
}

type junitTest struct {
	name string
	vq   []model.QueryResult
	file model.VulnerableFile
	want *junitTestSuites
}

var junitTests = []junitTest{
	{
		name: "Should not create any rule",
		vq:   []model.QueryResult{},
		file: model.VulnerableFile{},
		want: &junitTestSuites{
			Name:       "KICS " + constants.Version,
			Time:       now,
			Failures:   "0",
			TestSuites: make([]junitTestSuite, 0),
		},
	},
	{
		name: "Should create one occurrence",
		vq: []model.QueryResult{
			{
				QueryName:   "test",
				QueryID:     "1",
				Description: "test description",
				QueryURI:    "https://www.test.com",
				Severity:    model.SeverityHigh,
				Category:    "junit",
				Platform:    "Terraform",
				Files: []model.VulnerableFile{
					{KeyActualValue: "actual", KeyExpectedValue: "expected", FileName: "test.tf", Line: 1, SimilarityID: "similarity"},
				},
				CWE: "",
			},
		},
		file: model.VulnerableFile{
			KeyActualValue: "test",
			FileName:       "test.xml",
			Line:           1,
			SimilarityID:   "similarity",
		},
		want: &junitTestSuites{
			XMLName:  xml.Name{Space: "", Local: ""},
			Name:     "KICS " + constants.Version,
			Time:     now,
			Failures: "1",
			TestSuites: []junitTestSuite{
				{
					XMLName:   xml.Name{Space: "", Local: ""},
					failCount: 1,
					Name:      "Terraform",
					Failures:  "1",
					Tests:     "1",
					TestCases: []junitTestCase{
						{
							XMLName:   xml.Name{Space: "", Local: ""},
							Name:      "test: test.tf file in line 1",
							CWE:       "",
							ClassName: "Terraform",
							Failures: []junitFailure{
								{
									Type:    "test description",
									Message: "[Severity: HIGH, Query description: test description] Problem found on 'test.tf' file in line 1. Expected value: expected. Actual value: actual.",
								},
							},
						},
					},
				},
			},
		},
	},
	{
		name: "Should create one occurrence with cwe field complete",
		vq: []model.QueryResult{
			{
				QueryName:   "test",
				QueryID:     "1",
				Description: "test description",
				QueryURI:    "https://www.test.com",
				Severity:    model.SeverityHigh,
				Category:    "junit",
				Platform:    "Terraform",
				Files: []model.VulnerableFile{
					{KeyActualValue: "actual", KeyExpectedValue: "expected", FileName: "test.tf", Line: 1, SimilarityID: "similarity"},
				},
				CWE: "22",
			},
		},
		file: model.VulnerableFile{
			KeyActualValue: "test",
			FileName:       "test.xml",
			Line:           1,
			SimilarityID:   "similarity",
		},
		want: &junitTestSuites{
			XMLName:  xml.Name{Space: "", Local: ""},
			Name:     "KICS " + constants.Version,
			Time:     now,
			Failures: "1",
			TestSuites: []junitTestSuite{
				{
					XMLName:   xml.Name{Space: "", Local: ""},
					failCount: 1,
					Name:      "Terraform",
					Failures:  "1",
					Tests:     "1",
					TestCases: []junitTestCase{
						{
							XMLName:   xml.Name{Space: "", Local: ""},
							Name:      "test: test.tf file in line 1",
							CWE:       "22",
							ClassName: "Terraform",
							Failures: []junitFailure{
								{
									Type:    "test description",
									Message: "[Severity: HIGH, Query description: test description] Problem found on 'test.tf' file in line 1. Expected value: expected. Actual value: actual.",
								},
							},
						},
					},
				},
			},
		},
	},
	{
		name: "Should create one occurrence with critical severity",
		vq: []model.QueryResult{
			{
				QueryName:   "test",
				QueryID:     "1",
				Description: "test description",
				QueryURI:    "https://www.test.com",
				Severity:    model.SeverityCritical,
				Category:    "junit",
				Platform:    "Terraform",
				Files: []model.VulnerableFile{
					{KeyActualValue: "actual", KeyExpectedValue: "expected", FileName: "test.tf", Line: 1, SimilarityID: "similarity"},
				},
			},
		},
		file: model.VulnerableFile{
			KeyActualValue: "test",
			FileName:       "test.xml",
			Line:           1,
			SimilarityID:   "similarity",
		},
		want: &junitTestSuites{
			XMLName:  xml.Name{Space: "", Local: ""},
			Name:     "KICS " + constants.Version,
			Time:     now,
			Failures: "1",
			TestSuites: []junitTestSuite{
				{
					XMLName:   xml.Name{Space: "", Local: ""},
					failCount: 1,
					Name:      "Terraform",
					Failures:  "1",
					Tests:     "1",
					TestCases: []junitTestCase{
						{
							XMLName:   xml.Name{Space: "", Local: ""},
							Name:      "test: test.tf file in line 1",
							ClassName: "Terraform",
							Failures: []junitFailure{
								{
									Type:    "test description",
									Message: "[Severity: CRITICAL, Query description: test description] Problem found on 'test.tf' file in line 1. Expected value: expected. Actual value: actual.",
								},
							},
						},
					},
				},
			},
		},
	},
}

func TestJUnitReport(t *testing.T) {
	for _, tt := range junitTests {
		t.Run(tt.name, func(t *testing.T) {
			result := NewJUnitReport(now)
			for _, query := range tt.vq {
				result.GenerateTestEntry(&query)
			}
			result.FinishReport()
			require.Equal(t, tt.want, result)
		})
	}
}

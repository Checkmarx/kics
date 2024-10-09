package helpers

import (
	"fmt"
	"testing"

	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/Checkmarx/kics/v2/test"
	"github.com/stretchr/testify/require"
)

type resultExitCode struct {
	summary model.Summary
	failOn  map[string]struct{}
}

var resultsExitCodeTests = []struct {
	caseTest       resultExitCode
	expectedResult int
}{
	{
		caseTest: resultExitCode{
			summary: test.SummaryMock,
			failOn: map[string]struct{}{
				"critical": {},
				"high":     {},
				"medium":   {},
				"low":      {},
				"info":     {},
			},
		},
		expectedResult: 50,
	},
	{
		caseTest: resultExitCode{
			summary: test.SummaryMock,
			failOn: map[string]struct{}{
				"medium": {},
			},
		},
		expectedResult: 0,
	},
	{
		caseTest: resultExitCode{
			summary: test.ComplexSummaryMock,
			failOn: map[string]struct{}{
				"medium": {},
			},
		},
		expectedResult: 40,
	},
	{
		caseTest: resultExitCode{
			summary: test.ComplexSummaryMock,
			failOn: map[string]struct{}{
				"critical": {},
				"high":     {},
				"medium":   {},
				"low":      {},
				"info":     {},
			},
		},
		expectedResult: 60,
	},
}

func TestExitHandler_ResultsExitCode(t *testing.T) {
	for idx, testCase := range resultsExitCodeTests {
		t.Run(fmt.Sprintf("Print test case %d", idx), func(t *testing.T) {
			shouldFail = testCase.caseTest.failOn
			result := ResultsExitCode(&testCase.caseTest.summary)
			require.Equal(t, testCase.expectedResult, result)
		})
	}
}

type initIgnoreResult struct {
	wantErr bool
	want    string
}

var initShouldIgnoreExitCodeTests = []struct {
	caseTest       string
	expectedResult initIgnoreResult
}{
	{
		caseTest: "NONE",
		expectedResult: initIgnoreResult{
			wantErr: false,
			want:    "none",
		},
	},
	{
		caseTest: "None",
		expectedResult: initIgnoreResult{
			wantErr: false,
			want:    "none",
		},
	},
	{
		caseTest: "none",
		expectedResult: initIgnoreResult{
			wantErr: false,
			want:    "none",
		},
	},
	{
		caseTest: "all",
		expectedResult: initIgnoreResult{
			wantErr: false,
			want:    "all",
		},
	},
	{
		caseTest: "results",
		expectedResult: initIgnoreResult{
			wantErr: false,
			want:    "results",
		},
	},
	{
		caseTest: "errors",
		expectedResult: initIgnoreResult{
			wantErr: false,
			want:    "errors",
		},
	},
	{
		caseTest: "invalid",
		expectedResult: initIgnoreResult{
			wantErr: true,
			want:    "none",
		},
	},
}

func TestExitHandler_InitShouldIgnoreArg(t *testing.T) {
	for idx, testCase := range initShouldIgnoreExitCodeTests {
		t.Run(fmt.Sprintf("Print test case %d", idx), func(t *testing.T) {
			shouldIgnore = "none"
			err := InitShouldIgnoreArg(testCase.caseTest)
			if testCase.expectedResult.wantErr {
				require.NotNil(t, err)
			} else {
				require.Nil(t, err)
			}
			require.Equal(t, testCase.expectedResult.want, shouldIgnore)
		})
	}
}

type initFail struct {
	wantErr bool
	want    map[string]struct{}
}

var initShouldFailTests = []struct {
	caseTest       []string
	expectedResult initFail
}{
	{
		caseTest: []string{},
		expectedResult: initFail{
			wantErr: false,
			want: map[string]struct{}{
				"critical": {},
				"high":     {},
				"medium":   {},
				"low":      {},
				"info":     {},
			},
		},
	},
	{
		caseTest: []string{"HIGH"},
		expectedResult: initFail{
			wantErr: false,
			want: map[string]struct{}{
				"high": {},
			},
		},
	},
	{
		caseTest: []string{"Critical", "HIGH", "Medium", "loW", "info"},
		expectedResult: initFail{
			wantErr: false,
			want: map[string]struct{}{
				"critical": {},
				"high":     {},
				"medium":   {},
				"low":      {},
				"info":     {},
			},
		},
	},
	{
		caseTest: []string{"invalid"},
		expectedResult: initFail{
			wantErr: true,
			want:    map[string]struct{}{},
		},
	},
}

func TestExitHandler_InitShouldFailArg(t *testing.T) {
	for idx, testCase := range initShouldFailTests {
		t.Run(fmt.Sprintf("Print test case %d", idx), func(t *testing.T) {
			shouldFail = make(map[string]struct{})
			err := InitShouldFailArg(testCase.caseTest)
			if testCase.expectedResult.wantErr {
				require.NotNil(t, err)
			} else {
				require.Nil(t, err)
			}
			require.Equal(t, testCase.expectedResult.want, shouldFail)
		})
	}
}

var showResultsTests = []struct {
	caseTest       string
	expectedResult bool
}{
	{
		caseTest:       "none",
		expectedResult: true,
	},
	{
		caseTest:       "all",
		expectedResult: false,
	},
	{
		caseTest:       "results",
		expectedResult: true,
	},
	{
		caseTest:       "errors",
		expectedResult: false,
	},
}

func TestExitHandler_ShowError(t *testing.T) {
	for idx, testCase := range showResultsTests {
		t.Run(fmt.Sprintf("Print test case %d", idx), func(t *testing.T) {
			shouldIgnore = testCase.caseTest
			result := ShowError("errors")
			require.Equal(t, testCase.expectedResult, result)
		})
	}
}

func Test_RemediateAll(t *testing.T) {
	t.Run("RemediateAllExitCode", func(t *testing.T) {
		statusCode := RemediateExitCode(11, 11)
		require.Equal(t, statusCode, 0)
	})
}

func Test_RemediateNotAll(t *testing.T) {
	t.Run("RemediateNotAllExitCode", func(t *testing.T) {
		statusCode := RemediateExitCode(11, 6)
		require.Equal(t, statusCode, 70)
	})
}

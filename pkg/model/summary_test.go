package model

import (
	"testing"

	"github.com/stretchr/testify/require"
)

// TestCreateSummary tests the functions [CreateSummary()] and all the methods called by them
func TestCreateSummary(t *testing.T) {
	vulnerabilities := []Vulnerability{
		{
			ID:               1,
			ScanID:           "scanID",
			FileID:           "fileId",
			FileName:         "fileName",
			QueryID:          "QueryID",
			QueryName:        "query_name",
			Severity:         SeverityHigh,
			Line:             1,
			IssueType:        IssueTypeMissingAttribute,
			SearchKey:        "searchKey",
			KeyExpectedValue: "key_expected_value",
			KeyActualValue:   "key_actual_value",
			Output:           "-",
		},
	}

	counter := Counters{
		ScannedFiles:           2,
		ParsedFiles:            3,
		FailedToExecuteQueries: 0,
		TotalQueries:           0,
		FailedToScanFiles:      0,
	}

	t.Run("create_summary_empty", func(t *testing.T) {
		summary := CreateSummary(counter, []Vulnerability{}, "scanID")
		require.Equal(t, summary, Summary{
			Counters: counter,
			SeveritySummary: SeveritySummary{
				ScanID: "scanID",
				SeverityCounters: map[Severity]int{
					SeverityInfo:   0,
					SeverityLow:    0,
					SeverityMedium: 0,
					SeverityHigh:   0,
				},
			},
			Queries: []VulnerableQuery{},
		})
	})

	t.Run("create_summary", func(t *testing.T) {
		summary := CreateSummary(counter, vulnerabilities, "scanID")
		require.Equal(t, summary, Summary{
			Counters: counter,
			SeveritySummary: SeveritySummary{
				ScanID: "scanID",
				SeverityCounters: map[Severity]int{
					SeverityInfo:   0,
					SeverityLow:    0,
					SeverityMedium: 0,
					SeverityHigh:   1,
				},
				TotalCounter: 1,
			},
			Queries: []VulnerableQuery{
				{
					QueryName: "query_name",
					QueryID:   "QueryID",
					Severity:  SeverityHigh,
					Files: []VulnerableFile{
						{
							FileName:         "fileName",
							Line:             1,
							IssueType:        IssueTypeMissingAttribute,
							SearchKey:        "searchKey",
							KeyExpectedValue: "key_expected_value",
							KeyActualValue:   "key_actual_value",
							Value:            nil,
						},
					},
				},
			},
		})
	})
}

package model

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestCreateSummary(t *testing.T) {
	vulnerabilitys := []Vulnerability{
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
					"INFO":   0,
					"LOW":    0,
					"MEDIUM": 0,
					"HIGH":   0,
				},
			},
			Queries: []VulnerableQuery{},
		})
	})

	t.Run("create_summary", func(t *testing.T) {
		summary := CreateSummary(counter, vulnerabilitys, "scanID")
		require.Equal(t, summary, Summary{
			Counters: counter,
			SeveritySummary: SeveritySummary{
				ScanID: "scanID",
				SeverityCounters: map[Severity]int{
					"INFO":   0,
					"LOW":    0,
					"MEDIUM": 0,
					"HIGH":   1,
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

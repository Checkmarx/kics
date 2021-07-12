package model

import (
	"path/filepath"
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

	pathExtractionMap := map[string]ExtractedPathObject{}

	t.Run("create_summary_empty", func(t *testing.T) {
		summary := CreateSummary(counter, []Vulnerability{}, "scanID", pathExtractionMap)
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
		summary := CreateSummary(counter, vulnerabilities, "scanID", pathExtractionMap)
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

func TestModel_removeQueryParameters(t *testing.T) {
	type args struct {
		path     string
		splitted string
	}
	tests := []struct {
		name string
		args args
		want string
	}{
		{
			name: "cleanQueryPath No Queries",
			args: args{
				path:     "testing_path",
				splitted: "splitted_one",
			},
			want: filepath.Join("testing_path", "splitted_one"),
		},
		{
			name: "cleanQueryPath With Queries",
			args: args{
				path:     "testing_path?key=value",
				splitted: "splitted_one",
			},
			want: filepath.Join("testing_path", "splitted_one"),
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := removeQueryParameters(tt.args.path, tt.args.splitted)
			require.Equal(t, tt.want, got)
		})
	}
}

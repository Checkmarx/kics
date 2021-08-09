package model

import (
	"os"
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

func TestModel_resolvePath(t *testing.T) {
	pwd, err := os.Getwd()
	if err != nil {
		t.Errorf("failed to get working dir: %v", err)
	}

	type args struct {
		filePath          string
		pathExtractionMap map[string]ExtractedPathObject
	}
	tests := []struct {
		name string
		args args
		want string
	}{
		{
			name: "test_with_query_params_local",
			args: args{
				filePath: filepath.FromSlash("/tmp/file/vuln"),
				pathExtractionMap: map[string]ExtractedPathObject{
					filepath.FromSlash("/tmp"): {
						Path:      filepath.FromSlash("https//test/relativepath/testing?paramKey=paramVal"),
						LocalPath: false,
					},
				},
			},
			want: filepath.FromSlash("https//test/relativepath/testing/file/vuln"),
		},
		{
			name: "test_with_query_mult_params_local",
			args: args{
				filePath: filepath.FromSlash("/tmp/file/vuln"),
				pathExtractionMap: map[string]ExtractedPathObject{
					filepath.FromSlash("/tmp"): {
						Path:      filepath.FromSlash("https//test/relativepath/testing?paramKey=paramVal&paramKey2=paramVal2"),
						LocalPath: false,
					},
				},
			},
			want: filepath.FromSlash("https//test/relativepath/testing/file/vuln"),
		},
		{
			name: "test_with_query_local",
			args: args{
				filePath: filepath.Join(pwd, filepath.FromSlash("assets/queries/dockerfile/image_version_not_explicit/test/negative.dockerfile")),
				pathExtractionMap: map[string]ExtractedPathObject{
					filepath.FromSlash("/tmp"): {
						Path:      filepath.Join(pwd, filepath.FromSlash("/assets/queries/dockerfile")),
						LocalPath: true,
					},
				},
			},
			want: filepath.FromSlash("assets/queries/dockerfile/image_version_not_explicit/test/negative.dockerfile"),
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := resolvePath(tt.args.filePath, tt.args.pathExtractionMap)
			require.Equal(t, tt.want, got)
		})
	}
}

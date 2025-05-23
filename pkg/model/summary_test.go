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
			CWE:              "22",
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
		summary := CreateSummary(&counter, []Vulnerability{}, "scanID", pathExtractionMap, Version{})
		require.Equal(t, summary, Summary{
			Counters: counter,
			SeveritySummary: SeveritySummary{
				ScanID: "scanID",
				SeverityCounters: map[Severity]int{
					SeverityTrace:    0,
					SeverityInfo:     0,
					SeverityLow:      0,
					SeverityMedium:   0,
					SeverityHigh:     0,
					SeverityCritical: 0,
				},
			},
			Bom:          []QueryResult{},
			Queries:      []QueryResult{},
			ScannedPaths: []string{},
			FilePaths:    make(map[string]string),
		})
	})

	t.Run("create_summary", func(t *testing.T) {
		filePaths := make(map[string]string)
		filePaths["fileName"] = "fileName"
		summary := CreateSummary(&counter, vulnerabilities, "scanID", pathExtractionMap, Version{})
		require.Equal(t, summary, Summary{
			Counters: counter,
			SeveritySummary: SeveritySummary{
				ScanID: "scanID",
				SeverityCounters: map[Severity]int{
					SeverityTrace:    0,
					SeverityInfo:     0,
					SeverityLow:      0,
					SeverityMedium:   0,
					SeverityHigh:     1,
					SeverityCritical: 0,
				},
				TotalCounter: 1,
			},
			Bom: []QueryResult{},
			Queries: []QueryResult{
				{
					QueryName: "query_name",
					QueryID:   "QueryID",
					Severity:  SeverityHigh,
					CWE:       "22",
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
			ScannedPaths: []string{},
			FilePaths:    filePaths,
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

func TestRemoveURLCredentials(t *testing.T) {
	type args struct {
		url string
	}
	tests := []struct {
		name string
		args args
		want string
	}{
		{
			name: "test_with_url_credentials",
			args: args{
				url: "https://user:password@test.git.com/test.git",
			},
			want: "https://test.git.com/test.git",
		},
		{
			name: "test_with_url_no_credentials",
			args: args{
				url: "https://test.git.com/test.git",
			},
			want: "https://test.git.com/test.git",
		},
		{
			name: "test_http_with_url_credentials",
			args: args{
				url: "http://test:password@test.git.com/test",
			},
			want: "http://test.git.com/test",
		},
		{
			name: "test_https_with_url_token",
			args: args{
				url: "https://myTOken123a12e@test.git.com:8080/test",
			},
			want: "https://test.git.com:8080/test",
		},
	}
	for _, tt := range tests {
		require.Equal(t, tt.want, removeURLCredentials(tt.args.url))
	}
}

func TestRemoveAllURLCredentials(t *testing.T) {
	input := []struct {
		pathExtractionMap map[string]ExtractedPathObject
		want              map[string]string
	}{
		{
			pathExtractionMap: map[string]ExtractedPathObject{
				"/tmp/file/vuln": {
					Path:      "https://user:password@git1.url.com/test.git",
					LocalPath: false,
				},
				"/tmp/file/vuln2": {
					Path:      "https://myToken123@my2.domain/test.git",
					LocalPath: false,
				},
			},
			want: map[string]string{
				"/tmp/file/vuln":  "https://git1.url.com/test.git",
				"/tmp/file/vuln2": "https://my2.domain/test.git",
			},
		},
		{
			pathExtractionMap: map[string]ExtractedPathObject{
				"/tmp/file/vuln": {
					Path:      "/user/archive.zip",
					LocalPath: true,
				},
			},
			want: map[string]string{
				"/tmp/file/vuln": "/user/archive.zip",
			},
		},
	}
	for _, tt := range input {
		got := removeAllURLCredentials(tt.pathExtractionMap)
		for key := range tt.pathExtractionMap {
			require.Contains(t, got, tt.want[key])
		}
	}
}

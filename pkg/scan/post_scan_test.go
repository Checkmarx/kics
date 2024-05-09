package scan

import (
	"os"
	"path/filepath"
	"testing"
	"time"

	"github.com/Checkmarx/kics/v2/internal/tracker"
	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/Checkmarx/kics/v2/pkg/printer"
	"github.com/Checkmarx/kics/v2/pkg/progress"
	"github.com/stretchr/testify/require"
)

func Test_GetSummary(t *testing.T) {
	tests := []struct {
		name           string
		scanStartTime  time.Time
		endTime        time.Time
		scanParameters Parameters
		tracker        tracker.CITracker
		results        []model.Vulnerability
		pathParameters model.PathParameters
		expectedResult model.Summary
	}{
		{
			name: "test valid getSummary",
			tracker: tracker.CITracker{
				FoundFiles:         1,
				FoundCountLines:    1,
				ParsedCountLines:   1,
				IgnoreCountLines:   0,
				ParsedFiles:        1,
				LoadedQueries:      2,
				ExecutingQueries:   1,
				ExecutedQueries:    1,
				FailedSimilarityID: 12312312,
				Version: model.Version{
					Latest:           true,
					LatestVersionTag: "Dev",
				},
			},
			scanParameters: Parameters{
				DisableFullDesc: false,
			},
			results: []model.Vulnerability{
				{
					ScanID:       "console",
					SimilarityID: "ac0e0a60afa5543f6b26b90cecbf38da3341f44161289c172c91ea1a49652620",
					FileID:       "ac0e0a60afa5543f6b26b90cecbf38da3341f44161289c172c91ea1a49652620",
					FileName:     "/assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive2.tf",
					QueryID:      "c065b98e-1515-4991-9dca-b602bd6a2fbb",
					QueryName:    "Action Trail Logging For All Regions Disabled",
				},
			},
			endTime: time.Time{},
			pathParameters: model.PathParameters{
				ScannedPaths: []string{
					"./assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled",
					"./assets/queries/terraform/alicloud/actiontrail_trail_oss_bucket_is_publicly_accessible",
				},
				PathExtractionMap: map[string]model.ExtractedPathObject{
					"/tmp/kics-extract-927163672": {
						Path:      "./assets/queries/terraform/alicloud/actiontrail_trail_oss_bucket_is_publicly_accessible",
						LocalPath: true},
					"/tmp/kics-extract-026568029": {
						Path:      "./assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled",
						LocalPath: true},
				},
			},
			expectedResult: model.Summary{
				Version: "",
				LatestVersion: model.Version{
					Latest:           true,
					LatestVersionTag: "Dev",
				},
				Counters: model.Counters{
					ScannedFiles:           1,
					ScannedFilesLines:      1,
					ParsedFiles:            1,
					ParsedFilesLines:       1,
					FailedToScanFiles:      0,
					TotalQueries:           2,
					FailedToExecuteQueries: 0,
					FailedSimilarityID:     12312312,
				},
				SeveritySummary: model.SeveritySummary{
					ScanID: "",
					SeverityCounters: map[model.Severity]int{
						"TRACE":    0,
						"INFO":     0,
						"LOW":      0,
						"MEDIUM":   0,
						"HIGH":     0,
						"CRITICAL": 0,
						"":         1,
					},
					TotalCounter:      1,
					TotalBOMResources: 0,
				},
				ScannedPaths: []string{
					"./assets/queries/terraform/alicloud/actiontrail_trail_oss_bucket_is_publicly_accessible",
					"./assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled",
				},
			},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			c := Client{}
			c.Tracker = &tt.tracker
			c.ScanParams = &tt.scanParameters

			v := c.getSummary(tt.results, tt.endTime, tt.pathParameters)

			require.Equal(t, tt.expectedResult.Counters, v.Counters)
			require.Equal(t, tt.expectedResult.SeveritySummary, v.SeveritySummary)
			require.ElementsMatch(t, tt.expectedResult.ScannedPaths, tt.pathParameters.ScannedPaths)
		})
	}
}

func Test_PrintOutput(t *testing.T) {

	tests := []struct {
		name          string
		outputPath    string
		filename      string
		body          interface{}
		formats       []string
		proBarBuilder progress.PbBuilder
	}{
		{
			name:       "print result without output file",
			outputPath: "",
			filename:   "results",
			body: model.Summary{
				Version: "",
				LatestVersion: model.Version{
					Latest:           true,
					LatestVersionTag: "",
				},
				Counters: model.Counters{
					ScannedFiles:           10,
					ScannedFilesLines:      76,
					ParsedFiles:            10,
					ParsedFilesLines:       76,
					FailedToScanFiles:      0,
					TotalQueries:           1040,
					FailedToExecuteQueries: 0,
					FailedSimilarityID:     0,
				},
				SeveritySummary: model.SeveritySummary{
					ScanID:            "console",
					SeverityCounters:  map[model.Severity]int{},
					TotalCounter:      14,
					TotalBOMResources: 0,
				},
				Times: model.Times{},
				ScannedPaths: []string{
					"./assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled",
				},
				Queries: model.QueryResultSlice{},
				Bom:     model.QueryResultSlice{},
				FilePaths: map[string]string{
					"assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive7.tf": "/home/miguel/cx/kics/assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive7.tf",
					"assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive5.tf": "/home/miguel/cx/kics/assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive5.tf",
					"assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive6.tf": "/home/miguel/cx/kics/assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive6.tf",
					"assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive3.tf": "/home/miguel/cx/kics/assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive3.tf",
					"assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive8.tf": "/home/miguel/cx/kics/assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive8.tf",
					"assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive1.tf": "/home/miguel/cx/kics/assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive1.tf",
					"assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive4.tf": "/home/miguel/cx/kics/assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive4.tf",
					"assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive2.tf": "/home/miguel/cx/kics/assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive2.tf",
					"assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive9.tf": "/home/miguel/cx/kics/assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive9.tf",
				},
			},
			formats: []string{
				"json",
			},
			proBarBuilder: *progress.InitializePbBuilder(true, false, true),
		},
		{
			name:       "print with output path",
			outputPath: filepath.Join("..", ".."),
			filename:   "results",
			body: model.Summary{
				Version: "",
				LatestVersion: model.Version{
					Latest:           true,
					LatestVersionTag: "",
				},
				Counters: model.Counters{
					ScannedFiles:           10,
					ScannedFilesLines:      76,
					ParsedFiles:            10,
					ParsedFilesLines:       76,
					FailedToScanFiles:      0,
					TotalQueries:           1040,
					FailedToExecuteQueries: 0,
					FailedSimilarityID:     0,
				},
				SeveritySummary: model.SeveritySummary{
					ScanID:            "console",
					SeverityCounters:  map[model.Severity]int{},
					TotalCounter:      14,
					TotalBOMResources: 0,
				},
				Times: model.Times{},
				ScannedPaths: []string{
					"./assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled",
				},
				Queries: model.QueryResultSlice{},
				Bom:     model.QueryResultSlice{},
				FilePaths: map[string]string{
					"assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive7.tf": "/home/miguel/cx/kics/assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive7.tf",
					"assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive5.tf": "/home/miguel/cx/kics/assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive5.tf",
					"assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive6.tf": "/home/miguel/cx/kics/assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive6.tf",
					"assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive3.tf": "/home/miguel/cx/kics/assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive3.tf",
					"assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive8.tf": "/home/miguel/cx/kics/assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive8.tf",
					"assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive1.tf": "/home/miguel/cx/kics/assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive1.tf",
					"assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive4.tf": "/home/miguel/cx/kics/assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive4.tf",
					"assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive2.tf": "/home/miguel/cx/kics/assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive2.tf",
					"assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive9.tf": "/home/miguel/cx/kics/assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive9.tf",
				},
			},
			formats: []string{
				"json",
			},
			proBarBuilder: *progress.InitializePbBuilder(true, false, true),
		},
		{
			name:       "print with empty formats",
			outputPath: filepath.Join("..", ".."),
			filename:   "results",
			body: model.Summary{
				Version: "",
				LatestVersion: model.Version{
					Latest:           true,
					LatestVersionTag: "",
				},
				Counters: model.Counters{
					ScannedFiles:           10,
					ScannedFilesLines:      76,
					ParsedFiles:            10,
					ParsedFilesLines:       76,
					FailedToScanFiles:      0,
					TotalQueries:           1040,
					FailedToExecuteQueries: 0,
					FailedSimilarityID:     0,
				},
				SeveritySummary: model.SeveritySummary{
					ScanID:            "console",
					SeverityCounters:  map[model.Severity]int{},
					TotalCounter:      14,
					TotalBOMResources: 0,
				},
				Times: model.Times{},
				ScannedPaths: []string{
					"./assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled",
				},
				Queries: model.QueryResultSlice{},
				Bom:     model.QueryResultSlice{},
				FilePaths: map[string]string{
					"assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive7.tf": "/home/miguel/cx/kics/assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive7.tf",
					"assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive5.tf": "/home/miguel/cx/kics/assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive5.tf",
					"assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive6.tf": "/home/miguel/cx/kics/assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive6.tf",
					"assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive3.tf": "/home/miguel/cx/kics/assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive3.tf",
					"assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive8.tf": "/home/miguel/cx/kics/assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive8.tf",
					"assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive1.tf": "/home/miguel/cx/kics/assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive1.tf",
					"assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive4.tf": "/home/miguel/cx/kics/assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive4.tf",
					"assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive2.tf": "/home/miguel/cx/kics/assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive2.tf",
					"assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive9.tf": "/home/miguel/cx/kics/assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled/test/positive9.tf",
				},
			},
			formats:       []string{},
			proBarBuilder: *progress.InitializePbBuilder(true, false, true),
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			err := printOutput(tt.outputPath, tt.filename, tt.body, tt.formats, tt.proBarBuilder)
			os.Remove(filepath.Join("..", "..", tt.filename+".json"))
			require.NoError(t, err)
		})
	}

}

func Test_resolveOutputs(t *testing.T) {
	tests := []struct {
		name        string
		scanResults *Results
		scanParams  Parameters
		tracker     tracker.CITracker
		sevSummary  model.SeveritySummary
	}{
		{
			name:        "empty results",
			scanResults: nil,
			scanParams: Parameters{
				Path: []string{
					filepath.Join("..", "..", "lib"),
				},
			},
			tracker: tracker.CITracker{
				ExecutingQueries:   0,
				ExecutedQueries:    0,
				FoundFiles:         0,
				FailedSimilarityID: 0,
				LoadedQueries:      0,
				ParsedFiles:        0,
				ScanSecrets:        0,
				ScanPaths:          0,
				FoundCountLines:    0,
				ParsedCountLines:   0,
				Version: model.Version{
					Latest:           true,
					LatestVersionTag: "",
				},
			},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			c := Client{}
			c.Tracker = &tt.tracker
			c.ScanParams = &tt.scanParams
			c.ProBarBuilder = progress.InitializePbBuilder(true, false, true)
			c.Printer = printer.NewPrinter(true)
			err := c.postScan(tt.scanResults)
			require.NoError(t, err)
		})
	}
}

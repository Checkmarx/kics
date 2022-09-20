package scan

import (
	"testing"
	"time"

	"github.com/Checkmarx/kics/internal/tracker"
	"github.com/Checkmarx/kics/pkg/model"
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
				DisableCISDesc:  false,
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
						"TRACE":  0,
						"INFO":   0,
						"LOW":    0,
						"MEDIUM": 0,
						"HIGH":   0,
						"":       1,
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

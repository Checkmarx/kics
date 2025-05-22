package tracker

import (
	"reflect"
	"testing"

	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/Checkmarx/kics/v2/test"
	"github.com/stretchr/testify/require"
)

/*
TestCITracker tests the functions [TrackQueryLoad(),TrackQueryExecution(),TrackFileFound(),

	TrackFileParse(),TrackFileParse(),FailedDetectLine(),FailedComputeSimilarityID()]
*/
func TestCITracker(t *testing.T) {
	type fields struct {
		LoadedQueries         int
		ExecutedQueries       int
		ExecutingQueries      int
		FoundFiles            int
		ParsedFiles           int
		FailedSimilarityID    int
		FailedOldSimilarityID int
		ScanSecrets           int
		ScanPaths             int
		Version               model.Version
		FoundCountLines       int
		ParsedCountLines      int
		IgnoreCountLines      int
		lines                 int
	}
	tests := []struct {
		name   string
		fields fields
	}{
		{
			name: "testing_case_1",
			fields: fields{
				LoadedQueries:         0,
				ExecutedQueries:       0,
				ExecutingQueries:      0,
				FoundFiles:            0,
				ParsedFiles:           0,
				FailedSimilarityID:    0,
				FailedOldSimilarityID: 0,
				ScanSecrets:           0,
				ScanPaths:             0,
				Version:               model.Version{},
				FoundCountLines:       2,
				ParsedCountLines:      1,
				IgnoreCountLines:      4,
				lines:                 3,
			},
		},
	}

	for _, tt := range tests {
		c := &CITracker{
			LoadedQueries:      tt.fields.LoadedQueries,
			ExecutedQueries:    tt.fields.ExecutedQueries,
			ExecutingQueries:   tt.fields.ExecutingQueries,
			FoundFiles:         tt.fields.FoundFiles,
			ParsedFiles:        tt.fields.ParsedFiles,
			FailedSimilarityID: tt.fields.FailedSimilarityID,
			ScanSecrets:        tt.fields.ScanSecrets,
			ScanPaths:          tt.fields.ScanPaths,
			Version:            tt.fields.Version,
			FoundCountLines:    tt.fields.FoundCountLines,
			ParsedCountLines:   tt.fields.ParsedCountLines,
			IgnoreCountLines:   tt.fields.IgnoreCountLines,
			lines:              tt.fields.lines,
			BagOfFilesParse:    make(map[string]int),
			BagOfFilesFound:    make(map[string]int),
		}
		t.Run(tt.name+"_LoadedQueries", func(t *testing.T) {
			c.TrackQueryLoad(1)
			require.Equal(t, 1, c.LoadedQueries)
		})

		t.Run(tt.name+"_TrackQueryExecution", func(t *testing.T) {
			c.TrackQueryExecution(1)
			require.Equal(t, 1, c.ExecutedQueries)
		})

		t.Run(tt.name+"_TrackFileFound", func(t *testing.T) {
			c.TrackFileFound(tt.name)
			require.Equal(t, 1, c.FoundFiles)
		})

		t.Run(tt.name+"_TrackFileParse", func(t *testing.T) {
			c.TrackFileParse(tt.name)
			require.Equal(t, 1, c.ParsedFiles)
		})
		t.Run(tt.name+"_TrackQueryExecuting", func(t *testing.T) {
			c.TrackQueryExecuting(1)
			require.Equal(t, 1, c.ExecutingQueries)
		})
		t.Run(tt.name+"_FailedComputeSimilarityID", func(t *testing.T) {
			c.FailedComputeSimilarityID()
			require.Equal(t, 1, c.FailedSimilarityID)
		})
		t.Run(tt.name+"_FailedComputeOldSimilarityID", func(t *testing.T) {
			c.FailedComputeOldSimilarityID()
			require.Equal(t, 1, c.FailedOldSimilarityID)
		})
		t.Run(tt.name+"_FailedDetectLine", func(t *testing.T) {
			c.FailedDetectLine()
			require.Equal(t, 0, c.ExecutedQueries)
		})
		t.Run(tt.name+"_ScanSecrets", func(t *testing.T) {
			c.TrackScanSecret()
			require.Equal(t, 1, c.ScanSecrets)
		})
		t.Run(tt.name+"_ScanPaths", func(t *testing.T) {
			c.TrackScanPath()
			require.Equal(t, 1, c.ScanPaths)
		})
		t.Run(tt.name+"_TrackVersion", func(t *testing.T) {
			c.TrackVersion(model.Version{Latest: true, LatestVersionTag: "python:3.10"})
			require.Equal(t, model.Version{Latest: true, LatestVersionTag: "python:3.10"}, c.Version)
		})
		t.Run(tt.name+"_TrackFileFoundCountLines", func(t *testing.T) {
			c.TrackFileFoundCountLines(3)
			require.Equal(t, 5, c.FoundCountLines)
		})
		t.Run(tt.name+"_TrackFileParseCountLines", func(t *testing.T) {
			c.TrackFileParseCountLines(2)
			require.Equal(t, 3, c.ParsedCountLines)
		})
		t.Run(tt.name+"TrackFileIgnoreCountLines", func(t *testing.T) {
			c.TrackFileIgnoreCountLines(2)
			require.Equal(t, 6, c.IgnoreCountLines)
		})
		t.Run(tt.name+"_GetOutputLines", func(t *testing.T) {
			got := c.GetOutputLines()
			if !reflect.DeepEqual(got, 3) {
				t.Errorf("GetOutputLines() = %v, want = %v", got, 3)
			}
		})
	}
}

// TestNewTracker tests the functions [NewTracker()] and all the methods called by them
func TestNewTracker(t *testing.T) {
	type args struct {
		outputLines int
	}
	tests := []struct {
		name    string
		args    args
		want    CITracker
		wantErr bool
	}{
		{
			name: "test_new_ci_tracker",
			args: args{
				outputLines: 3,
			},
			want: CITracker{
				lines:           3,
				BagOfFilesFound: make(map[string]int),
				BagOfFilesParse: make(map[string]int),
			},
			wantErr: false,
		},
		{
			name: "test_tracker_error",
			args: args{
				outputLines: 0,
			},
			want:    CITracker{},
			wantErr: true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := NewTracker(tt.args.outputLines)
			gotStrVulnerabilities, errStr := test.StringifyStruct(*got)
			require.Nil(t, errStr)
			wantStrVulnerabilities, errStr := test.StringifyStruct(tt.want)
			require.Nil(t, errStr)
			if (err != nil) != tt.wantErr {
				t.Errorf("NewTracker() error = %v, wantErr = %v", err, tt.wantErr)
				return
			}
			if !reflect.DeepEqual(gotStrVulnerabilities, wantStrVulnerabilities) {
				t.Errorf("NewTracker() = %v, want = %v", gotStrVulnerabilities, wantStrVulnerabilities)
			}
		})
	}
}

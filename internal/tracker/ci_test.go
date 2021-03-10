package tracker

import (
	"fmt"
	"reflect"
	"testing"

	"github.com/Checkmarx/kics/test"
	"github.com/stretchr/testify/require"
)

/*
TestCITracker tests the functions [TrackQueryLoad(),TrackQueryExecution(),TrackFileFound(),
	TrackFileParse(),TrackFileParse(),FailedDetectLine(),FailedComputeSimilarityID()]
*/
func TestCITracker(t *testing.T) {
	type fields struct {
		LoadedQueries      int
		ExecutedQueries    int
		FoundFiles         int
		ParsedFiles        int
		FailedSimilarityID int
		lines              int
	}
	tests := []struct {
		name   string
		fields fields
	}{
		{
			name: "testing_case_1",
			fields: fields{
				LoadedQueries:      0,
				ExecutedQueries:    0,
				FoundFiles:         0,
				ParsedFiles:        0,
				FailedSimilarityID: 0,
				lines:              3,
			},
		},
	}

	for _, tt := range tests {
		c := &CITracker{
			LoadedQueries:      tt.fields.LoadedQueries,
			ExecutedQueries:    tt.fields.ExecutedQueries,
			FoundFiles:         tt.fields.FoundFiles,
			ParsedFiles:        tt.fields.ParsedFiles,
			FailedSimilarityID: tt.fields.FailedSimilarityID,
			lines:              tt.fields.lines,
		}
		t.Run(fmt.Sprintf(tt.name+"_LoadedQueries"), func(t *testing.T) {
			c.TrackQueryLoad(1)
			require.Equal(t, 1, c.LoadedQueries)
		})

		t.Run(fmt.Sprintf(tt.name+"_TrackQueryExecution"), func(t *testing.T) {
			c.TrackQueryExecution(1)
			require.Equal(t, 1, c.ExecutedQueries)
		})

		t.Run(fmt.Sprintf(tt.name+"_TrackFileFound"), func(t *testing.T) {
			c.TrackFileFound()
			require.Equal(t, 1, c.FoundFiles)
		})

		t.Run(fmt.Sprintf(tt.name+"_TrackFileParse"), func(t *testing.T) {
			c.TrackFileParse()
			require.Equal(t, 1, c.ParsedFiles)
		})
		t.Run(fmt.Sprintf(tt.name+"_FailedDetectLine"), func(t *testing.T) {
			c.FailedDetectLine()
			require.Equal(t, 0, c.ExecutedQueries)
		})
		t.Run(fmt.Sprintf(tt.name+"_FailedComputeSimilarityID"), func(t *testing.T) {
			c.FailedComputeSimilarityID()
			require.Equal(t, 1, c.FailedSimilarityID)
		})
		t.Run(fmt.Sprintf(tt.name+"_GetOutputLines"), func(t *testing.T) {
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
				lines: 3,
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

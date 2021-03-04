package tracker

import (
	"fmt"
	"testing"

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
	}
}

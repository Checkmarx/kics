package tracker

import (
	"fmt"

	"github.com/Checkmarx/kics/internal/constants"
)

// CITracker contains information of how many queries were loaded and executed
// and how many files were found and executed
type CITracker struct {
	ExecutingQueries   int
	ExecutedQueries    int
	FoundFiles         int
	FailedSimilarityID int
	LoadedQueries      int
	ParsedFiles        int
	ScanSecrets        int
	lines              int
}

// NewTracker will create a new instance of a tracker with the number of lines to display in results output
// number of lines can not be smaller than 1
func NewTracker(previewLines int) (*CITracker, error) {
	if previewLines < constants.MinimumPreviewLines || previewLines > constants.MaximumPreviewLines {
		return &CITracker{},
			fmt.Errorf("output lines minimum is %v and maximum is %v", constants.MinimumPreviewLines, constants.MaximumPreviewLines)
	}
	return &CITracker{
		lines: previewLines,
	}, nil
}

// GetOutputLines returns the number of lines to display in results output
func (c *CITracker) GetOutputLines() int {
	return c.lines
}

// TrackQueryLoad adds a loaded query
func (c *CITracker) TrackQueryLoad(queryAggregation int) {
	c.LoadedQueries += queryAggregation
}

// TrackQueryExecuting adds a executing queries
func (c *CITracker) TrackQueryExecuting(queryAggregation int) {
	c.ExecutingQueries += queryAggregation
}

// TrackQueryExecution adds a query executed
func (c *CITracker) TrackQueryExecution(queryAggregation int) {
	c.ExecutedQueries += queryAggregation
}

// TrackFileFound adds a found file to be scanned
func (c *CITracker) TrackFileFound() {
	c.FoundFiles++
}

// TrackFileParse adds a successful parsed file to be scanned
func (c *CITracker) TrackFileParse() {
	c.ParsedFiles++
}

// FailedDetectLine - queries that fail to detect line are counted as failed to execute queries
func (c *CITracker) FailedDetectLine() {
	c.ExecutedQueries--
}

// FailedComputeSimilarityID - queries that failed to compute similarity ID
func (c *CITracker) FailedComputeSimilarityID() {
	c.FailedSimilarityID++
}

func (c *CITracker) TrackScanSecrets() {
	c.ScanSecrets++
}

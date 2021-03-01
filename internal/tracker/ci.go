package tracker

import "errors"

// CITracker contains information of how many queries were loaded and executed
// and how many files were found and executed
type CITracker struct {
	LoadedQueries      int
	ExecutedQueries    int
	FoundFiles         int
	ParsedFiles        int
	FailedSimilarityID int
	lines              int
}

// NewTracker will create a new instance of a tracker with the number of lines to display in results output
// number of lines can not be smaller than 1
func NewTracker(outputLines int) (*CITracker, error) {
	if outputLines < 1 {
		return &CITracker{}, errors.New("output lines number minimum is 1")
	}
	return &CITracker{
		lines: outputLines,
	}, nil
}

// GetOutputLines returns the number of lines to display in results output
func (c *CITracker) GetOutputLines() int {
	return c.lines
}

// TrackQueryLoad adds a loaded query
func (c *CITracker) TrackQueryLoad() {
	c.LoadedQueries++
}

// TrackQueryExecution adds a query executed
func (c *CITracker) TrackQueryExecution() {
	c.ExecutedQueries++
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

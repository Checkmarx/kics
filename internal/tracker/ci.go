package tracker

// CITracker contains information of how many queries were loaded and executed
// and how many files were found and executed
type CITracker struct {
	LoadedQueries      int
	ExecutedQueries    int
	FoundFiles         int
	ParsedFiles        int
	FailedSimilarityID int
}

// TrackQueryLoad adds a loaded query
func (c *CITracker) TrackQueryLoad(queryAggregation int) {
	c.LoadedQueries += queryAggregation
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

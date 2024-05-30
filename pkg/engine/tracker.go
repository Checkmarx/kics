package engine

// Tracker wraps an interface that contain basic methods: TrackQueryLoad, TrackQueryExecution and FailedDetectLine
// TrackQueryLoad increments the number of loaded queries
// TrackQueryExecution increments the number of queries executed
// FailedDetectLine decrements the number of queries executed
// GetOutputLines returns the number of lines to be displayed in results outputs
type Tracker interface {
	TrackQueryLoad(queryAggregation int)
	TrackQueryExecuting(queryAggregation int)
	TrackQueryExecution(queryAggregation int)
	TrackScanPath()
	TrackScanSecret()
	FailedDetectLine()
	FailedComputeSimilarityID()
	FailedComputeOldSimilarityID()
	GetOutputLines() int
}

package tracker

type CITracker struct {
	LoadedQueries   int
	ExecutedQueries int
	FoundFiles      int
	ParsedFiles     int
}

func (c *CITracker) TrackQueryLoad() {
	c.LoadedQueries++
}

func (c *CITracker) TrackQueryExecution() {
	c.ExecutedQueries++
}

func (c *CITracker) TrackFileFound() {
	c.FoundFiles++
}

func (c *CITracker) TrackFileParse() {
	c.ParsedFiles++
}

// FailedDetectLine - queries that fail to detect line are counted as failed to execute queries
func (c *CITracker) FailedDetectLine() {
	c.ExecutedQueries--
}

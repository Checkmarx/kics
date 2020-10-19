package tracker

type NullTracker struct{}

func (c *NullTracker) TrackQueryLoad() {}

func (c *NullTracker) TrackQueryExecution() {}

func (c *NullTracker) TrackFileFound() {}

func (c *NullTracker) TrackFileParse() {}

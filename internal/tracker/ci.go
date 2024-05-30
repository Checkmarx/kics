package tracker

import (
	"fmt"
	"sync"

	"github.com/Checkmarx/kics/v2/internal/constants"
	"github.com/Checkmarx/kics/v2/pkg/model"
)

// CITracker contains information of how many queries were loaded and executed
// and how many files were found and executed

var (
	trackerMu sync.Mutex
)

type CITracker struct {
	ExecutingQueries      int
	ExecutedQueries       int
	FoundFiles            int
	FailedSimilarityID    int
	FailedOldSimilarityID int
	LoadedQueries         int
	ParsedFiles           int
	ScanSecrets           int
	ScanPaths             int
	lines                 int
	FoundCountLines       int
	ParsedCountLines      int
	IgnoreCountLines      int
	Version               model.Version
	BagOfFilesParse       map[string]int
	BagOfFilesFound       map[string]int
	syncFileMutex         sync.Mutex
}

// NewTracker will create a new instance of a tracker with the number of lines to display in results output
// number of lines can not be smaller than 1
func NewTracker(previewLines int) (*CITracker, error) {
	if previewLines < constants.MinimumPreviewLines || previewLines > constants.MaximumPreviewLines {
		return &CITracker{},
			fmt.Errorf("output lines minimum is %v and maximum is %v", constants.MinimumPreviewLines, constants.MaximumPreviewLines)
	}
	return &CITracker{
		lines:           previewLines,
		BagOfFilesParse: make(map[string]int),
		BagOfFilesFound: make(map[string]int),
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
	trackerMu.Lock()
	defer trackerMu.Unlock()
	c.ExecutedQueries += queryAggregation
}

// TrackFileFound adds a found file to be scanned
func (c *CITracker) TrackFileFound(path string) {
	c.syncFileMutex.Lock()
	defer c.syncFileMutex.Unlock()
	count, value := c.BagOfFilesFound[path]
	if !value {
		c.BagOfFilesFound[path] = 1
		c.FoundFiles++
	} else {
		c.BagOfFilesFound[path] = count + 1
	}
}

// TrackFileParse adds a successful parsed file to be scanned
func (c *CITracker) TrackFileParse(path string) {
	c.syncFileMutex.Lock()
	defer c.syncFileMutex.Unlock()
	count, value := c.BagOfFilesParse[path]
	if !value {
		c.BagOfFilesParse[path] = 1
		c.ParsedFiles++
	} else {
		c.BagOfFilesParse[path] = count + 1
	}
}

// FailedDetectLine - queries that fail to detect line are counted as failed to execute queries
func (c *CITracker) FailedDetectLine() {
	c.ExecutedQueries--
}

// FailedComputeSimilarityID - queries that failed to compute similarity ID
func (c *CITracker) FailedComputeSimilarityID() {
	c.FailedSimilarityID++
}

// FailedComputeOldSimilarityID - queries that failed to compute old similarity ID
func (c *CITracker) FailedComputeOldSimilarityID() {
	c.FailedOldSimilarityID++
}

// TrackScanSecret - add to secrets scanned
func (c *CITracker) TrackScanSecret() {
	c.ScanSecrets++
}

// TrackScanPath - paths to preform scan
func (c *CITracker) TrackScanPath() {
	c.ScanPaths++
}

// TrackVersion - information if current version is latest
func (c *CITracker) TrackVersion(retrievedVersion model.Version) {
	c.Version = retrievedVersion
}

// TrackFileFoundCountLines - information about the lines of the scanned files
func (c *CITracker) TrackFileFoundCountLines(countLines int) {
	c.FoundCountLines += countLines
}

// TrackFileParseCountLines - information about the lines of the parsed files
func (c *CITracker) TrackFileParseCountLines(countLines int) {
	c.ParsedCountLines += countLines
}

// TrackFileIgnoreCountLines - information about the lines ignored of the parsed files
func (c *CITracker) TrackFileIgnoreCountLines(countLines int) {
	c.IgnoreCountLines += countLines
}

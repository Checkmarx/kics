package scan

import (
	"context"
	"time"

	consoleHelpers "github.com/Checkmarx/kics/internal/console/helpers"
	"github.com/Checkmarx/kics/internal/storage"
	"github.com/Checkmarx/kics/internal/tracker"
	"github.com/Checkmarx/kics/pkg/engine/source"
	"github.com/Checkmarx/kics/pkg/progress"
	"github.com/rs/zerolog/log"
)

type Parameters struct {
	CloudProvider               []string
	DisableCISDesc              bool
	DisableFullDesc             bool
	ExcludeCategories           []string
	ExcludePaths                []string
	ExcludeQueries              []string
	ExcludeResults              []string
	ExcludeSeverities           []string
	IncludeQueries              []string
	InputData                   string
	OutputName                  string
	OutputPath                  string
	Path                        []string
	PayloadPath                 string
	PreviewLines                int
	QueriesPath                 string
	LibrariesPath               string
	ReportFormats               []string
	Type                        []string
	QueryExecTimeout            int
	LineInfoPayload             bool
	DisableSecrets              bool
	SecretsRegexesPath          string
	ChangedDefaultQueryPath     bool
	ChangedDefaultLibrariesPath bool
	ScanID                      string
}

type Client struct {
	ScanParams        *Parameters
	ScanStartTime     time.Time
	Tracker           *tracker.CITracker
	Storage           *storage.MemoryStorage
	ExcludeResultsMap map[string]bool
	QuerySource       *source.FilesystemSource
	Printer           *consoleHelpers.Printer
	ProBarBuilder     *progress.PbBuilder
}

// NewClient initializes the client with all the required parameters
func NewClient(params *Parameters, proBarBuilder *progress.PbBuilder, printer *consoleHelpers.Printer) (*Client, error) {
	t, err := tracker.NewTracker(params.PreviewLines)
	if err != nil {
		log.Err(err)
		return nil, err
	}

	store := storage.NewMemoryStorage()

	excludeResultsMap := getExcludeResultsMap(params.ExcludeResults)

	querySource := source.NewFilesystemSource(
		params.QueriesPath,
		params.Type,
		params.CloudProvider,
		params.LibrariesPath)

	return &Client{
		ScanParams:        params,
		Tracker:           t,
		ProBarBuilder:     proBarBuilder,
		Storage:           store,
		ExcludeResultsMap: excludeResultsMap,
		QuerySource:       querySource,
		Printer:           printer,
	}, err
}

// PerformScan executes pre_scan, scan, and post_scan
func (c *Client) PerformScan(ctx context.Context) error {
	c.ScanStartTime = time.Now()

	scanResults, err := c.scan(ctx)

	if err != nil {
		log.Err(err)
		return err
	}

	postScanError := c.postScan(scanResults)

	if postScanError != nil {
		log.Err(postScanError)
		return postScanError
	}

	return nil
}

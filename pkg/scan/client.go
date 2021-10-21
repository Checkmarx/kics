package scan

import (
	"context"
	"time"

	consoleHelpers "github.com/Checkmarx/kics/internal/console/helpers"
	"github.com/Checkmarx/kics/internal/storage"
	"github.com/Checkmarx/kics/internal/tracker"
	"github.com/Checkmarx/kics/pkg/descriptions"
	"github.com/Checkmarx/kics/pkg/progress"
	"github.com/rs/zerolog/log"
)

// Parameters represents all available scan parameters
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
	Platform                    []string
	QueryExecTimeout            int
	LineInfoPayload             bool
	DisableSecrets              bool
	SecretsRegexesPath          string
	ChangedDefaultQueryPath     bool
	ChangedDefaultLibrariesPath bool
	ScanID                      string
}

// Client represents a scan client
type Client struct {
	ScanParams        *Parameters
	ScanStartTime     time.Time
	Tracker           *tracker.CITracker
	Storage           *storage.MemoryStorage
	ExcludeResultsMap map[string]bool
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

	if err = descriptions.CheckVersion(t); err != nil {
		log.Err(err).Msgf("failed to check latest version")
	}

	store := storage.NewMemoryStorage()

	excludeResultsMap := getExcludeResultsMap(params.ExcludeResults)

	return &Client{
		ScanParams:        params,
		Tracker:           t,
		ProBarBuilder:     proBarBuilder,
		Storage:           store,
		ExcludeResultsMap: excludeResultsMap,
		Printer:           printer,
	}, err
}

// PerformScan executes executeScan and postScan
func (c *Client) PerformScan(ctx context.Context) error {
	c.ScanStartTime = time.Now()

	scanResults, err := c.executeScan(ctx)

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

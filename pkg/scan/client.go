package scan

import (
	"context"
	"time"

	"github.com/Checkmarx/kics/v2/internal/storage"
	"github.com/Checkmarx/kics/v2/internal/tracker"
	"github.com/Checkmarx/kics/v2/pkg/descriptions"
	consolePrinter "github.com/Checkmarx/kics/v2/pkg/printer"
	"github.com/Checkmarx/kics/v2/pkg/progress"
	"github.com/rs/zerolog/log"
)

// Parameters represents all available scan parameters
type Parameters struct {
	CloudProvider               []string
	DisableFullDesc             bool
	ExcludeCategories           []string
	ExcludePaths                []string
	ExcludeQueries              []string
	ExcludeResults              []string
	ExcludeSeverities           []string
	ExperimentalQueries         bool
	IncludeQueries              []string
	InputData                   string
	OutputName                  string
	OutputPath                  string
	Path                        []string
	PayloadPath                 string
	PreviewLines                int
	QueriesPath                 []string
	LibrariesPath               string
	ReportFormats               []string
	Platform                    []string
	ExcludePlatform             []string
	TerraformVarsPath           string
	QueryExecTimeout            int
	LineInfoPayload             bool
	DisableSecrets              bool
	SecretsRegexesPath          string
	ChangedDefaultQueryPath     bool
	ChangedDefaultLibrariesPath bool
	ScanID                      string
	BillOfMaterials             bool
	ExcludeGitIgnore            bool
	OpenAPIResolveReferences    bool
	ParallelScanFlag            int
	MaxFileSizeFlag             int
	UseOldSeverities            bool
	MaxResolverDepth            int
	KicsComputeNewSimID         bool
}

// Client represents a scan client
type Client struct {
	ScanParams        *Parameters
	ScanStartTime     time.Time
	Tracker           *tracker.CITracker
	Storage           *storage.MemoryStorage
	ExcludeResultsMap map[string]bool
	Printer           *consolePrinter.Printer
	ProBarBuilder     *progress.PbBuilder
}

// NewClient initializes the client with all the required parameters
func NewClient(params *Parameters, proBarBuilder *progress.PbBuilder, customPrint *consolePrinter.Printer) (*Client, error) {
	t, err := tracker.NewTracker(params.PreviewLines)
	if err != nil {
		log.Err(err)
		return nil, err
	}

	descriptions.CheckVersion(t)

	store := storage.NewMemoryStorage()

	excludeResultsMap := getExcludeResultsMap(params.ExcludeResults)

	return &Client{
		ScanParams:        params,
		Tracker:           t,
		ProBarBuilder:     proBarBuilder,
		Storage:           store,
		ExcludeResultsMap: excludeResultsMap,
		Printer:           customPrint,
	}, nil
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

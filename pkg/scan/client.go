package scan

import (
	"context"
	"time"

	consoleHelpers "github.com/Checkmarx/kics/internal/console/helpers"
	"github.com/Checkmarx/kics/internal/tracker"
	"github.com/Checkmarx/kics/pkg/engine/provider"
	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/pkg/progress"
	"github.com/rs/zerolog/log"
)

type Parameters struct {
	CloudProviderFlag           []string
	ConfigFlag                  string
	DisableCISDescFlag          bool
	DisableFullDescFlag         bool
	ExcludeCategoriesFlag       []string
	ExcludePathsFlag            []string
	ExcludeQueriesFlag          []string
	ExcludeResultsFlag          []string
	ExcludeSeveritiesFlag       []string
	IncludeQueriesFlag          []string
	InputDataFlag               string
	FailOnFlag                  []string
	IgnoreOnExitFlag            string
	MinimalUIFlag               bool
	NoProgressFlag              bool
	OutputNameFlag              string
	OutputPathFlag              string
	PathFlag                    []string
	PayloadPathFlag             string
	PreviewLinesFlag            int
	QueriesPath                 string
	LibrariesPath               string
	ReportFormatsFlag           []string
	TypeFlag                    []string
	QueryExecTimeoutFlag        int
	LineInfoPayloadFlag         bool
	DisableSecretsFlag          bool
	SecretsRegexesPathFlag      string
	CIFlag                      bool   // tirar?
	LogFormatFlag               string // tirar?
	LogLevelFlag                string // tirar?
	LogPathFlag                 string // tirar?
	NoColorFlag                 bool   // tirar?
	ProfilingFlag               string // tirar?
	SilentFlag                  bool   // tirar?
	VerboseFlag                 bool   // tirar?
	ChangedDefaultQueryPath     bool
	ChangedDefaultLibrariesPath bool
	ScanID                      string
}

type Client struct {
	ScanParams     *Parameters
	ScanStartTime  time.Time
	Tracker        *tracker.CITracker
	Results        []model.Vulnerability
	ExtractedPaths provider.ExtractedPath
	Files          model.FileMetadatas
	FailedQueries  map[string]error
	Printer        *consoleHelpers.Printer
	ProBarBuilder  *progress.PbBuilder
	ProgressBar    progress.PBar
}

// NewClient
func NewClient(params *Parameters) *Client {
	return &Client{ScanParams: params}
}

// PerformScan executes pre_scan, scan, and post_scan
func (c *Client) PerformScan(ctx context.Context) error {
	c.ScanStartTime = time.Now()

	err := c.scan(ctx)

	if err != nil {
		log.Err(err)
		return err
	}

	postScanError := c.postScan()

	if postScanError != nil {
		log.Err(postScanError)
		return postScanError
	}

	return nil
}

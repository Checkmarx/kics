package scan

import (
	"context"

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

var ScanParams Parameters

// PerformScan executes pre_scan, scan, and post_scan
func PerformScan(ctx context.Context, banner string) error {
	printer, proBarBuilder, progressBar, scanStartTime := preScan(banner)

	// meter start time
	returnScanParams, err := scan(ctx, proBarBuilder, progressBar)

	if err != nil {
		log.Err(err)
		return err
	}

	postScanError := posScan(returnScanParams.t, returnScanParams.results, scanStartTime,
		returnScanParams.extractedPaths, returnScanParams.files, returnScanParams.failedQueries, printer, proBarBuilder)

	if postScanError != nil {
		log.Err(postScanError)
		return postScanError
	}

	// tempo q decorreu

	return nil
}

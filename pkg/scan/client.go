package scan

import (
	"context"
	"encoding/json"
	"io"
	"net/http"
	"time"

	"github.com/rs/zerolog/log"

	"github.com/Checkmarx/kics/v2/internal/constants"
	"github.com/Checkmarx/kics/v2/internal/storage"
	"github.com/Checkmarx/kics/v2/internal/tracker"
	"github.com/Checkmarx/kics/v2/pkg/model"
	consolePrinter "github.com/Checkmarx/kics/v2/pkg/printer"
	"github.com/Checkmarx/kics/v2/pkg/progress"
)

var versionHTTPClient = &http.Client{
	Timeout: 20 * time.Second,
}

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
	StrictSourceResolution      bool
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

	CheckVersion(t)

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

func CheckVersion(t *tracker.CITracker) {
	baseVersionInfo := model.Version{Latest: true}

	if constants.Version == "development" {
		t.TrackVersion(baseVersionInfo)
		return
	}

	resp, err := versionHTTPClient.Get("https://api.github.com/repos/Checkmarx/kics/releases/latest")
	
	if err != nil {
		t.TrackVersion(baseVersionInfo)
		return
	}
	defer resp.Body.Close()

	if resp.StatusCode == http.StatusNotFound {
		t.TrackVersion(baseVersionInfo)
		return
	}

	b, err := io.ReadAll(resp.Body)
	if err != nil {
		t.TrackVersion(baseVersionInfo)
		return
	}

	var release struct {
		TagName string `json:"tag_name"`
	}
	if err := json.Unmarshal(b, &release); err != nil {
		t.TrackVersion(baseVersionInfo)
		return
	}

	t.TrackVersion(model.Version{
		Latest:           constants.Version == release.TagName,
		LatestVersionTag: release.TagName,
	})
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

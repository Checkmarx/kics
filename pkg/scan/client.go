/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache-2.0 License.
 *
 * This product includes software developed at Datadog (https://www.datadoghq.com)  Copyright 2024 Datadog, Inc.
 */
package scan

import (
	"context"
	"time"

	"github.com/Checkmarx/kics/internal/storage"
	"github.com/Checkmarx/kics/internal/tracker"
	"github.com/Checkmarx/kics/pkg/descriptions"
	"github.com/Checkmarx/kics/pkg/model"
	consolePrinter "github.com/Checkmarx/kics/pkg/printer"
	"github.com/Checkmarx/kics/pkg/progress"
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
	SCIInfo                     model.SCIInfo
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

func GetDefaultParameters() *Parameters {
	return &Parameters{
		CloudProvider:               []string{""},
		DisableFullDesc:             false,
		ExcludeCategories:           []string{},
		ExcludeQueries:              []string{},
		ExcludeResults:              []string{},
		ExcludeSeverities:           []string{},
		ExcludePaths:                []string{},
		ExperimentalQueries:         false,
		IncludeQueries:              []string{},
		InputData:                   "",
		OutputName:                  "kics-result",
		PayloadPath:                 "",
		PreviewLines:                3,
		QueriesPath:                 []string{"../../../assets/queries"},
		LibrariesPath:               "../../../assets/libraries",
		ReportFormats:               []string{"sarif"},
		Platform:                    []string{""},
		TerraformVarsPath:           "",
		QueryExecTimeout:            60,
		LineInfoPayload:             false,
		DisableSecrets:              true,
		SecretsRegexesPath:          "",
		ChangedDefaultQueryPath:     false,
		ChangedDefaultLibrariesPath: false,
		ScanID:                      "console",
		BillOfMaterials:             false,
		ExcludeGitIgnore:            false,
		OpenAPIResolveReferences:    false,
		ParallelScanFlag:            0,
		MaxFileSizeFlag:             5,
		UseOldSeverities:            false,
		MaxResolverDepth:            15,
		ExcludePlatform:             []string{""},
	}
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

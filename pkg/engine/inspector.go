package engine

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"reflect"
	"strings"
	"time"

	"github.com/Checkmarx/kics/internal/metrics"
	sentryReport "github.com/Checkmarx/kics/internal/sentry"
	"github.com/Checkmarx/kics/pkg/detector"
	"github.com/Checkmarx/kics/pkg/detector/docker"
	"github.com/Checkmarx/kics/pkg/detector/helm"
	"github.com/Checkmarx/kics/pkg/engine/kicsgpt"
	"github.com/Checkmarx/kics/pkg/engine/source"
	"github.com/Checkmarx/kics/pkg/model"
	"github.com/open-policy-agent/opa/ast"
	"github.com/open-policy-agent/opa/cover"
	"github.com/open-policy-agent/opa/rego"
	"github.com/open-policy-agent/opa/storage/inmem"
	"github.com/open-policy-agent/opa/topdown"
	"github.com/open-policy-agent/opa/util"
	"github.com/pkg/errors"
	"github.com/rs/zerolog/log"
)

// Default values for inspector
const (
	UndetectedVulnerabilityLine = -1
	DefaultQueryID              = "Undefined"
	DefaultQueryName            = "Anonymous"
	DefaultQueryDescription     = "Undefined"
	DefaultQueryDescriptionID   = "Undefined"
	DefaultQueryURI             = "https://github.com/Checkmarx/kics/"
	DefaultIssueType            = model.IssueTypeIncorrectValue

	regoQuery = `result = data.Cx.CxPolicy`
)

// ErrNoResult - error representing when a query didn't return a result
var ErrNoResult = errors.New("query: not result")

// ErrInvalidResult - error representing invalid result
var ErrInvalidResult = errors.New("query: invalid result format")

// QueryLoader is responsible for loading the queries for the inspector
type QueryLoader struct {
	commonLibrary     source.RegoLibraries
	platformLibraries map[string]source.RegoLibraries
	querySum          int
	QueriesMetadata   []model.QueryMetadata
}

// VulnerabilityBuilder represents a function that will build a vulnerability
type VulnerabilityBuilder func(ctx *QueryContext, tracker Tracker, v interface{},
	detector *detector.DetectLine) (*model.Vulnerability, error)

// PreparedQuery includes the opaQuery and its metadata
type PreparedQuery struct {
	OpaQuery rego.PreparedEvalQuery
	Metadata model.QueryMetadata
}

// Inspector represents a list of compiled queries, a builder for vulnerabilities, an information tracker
// a flag to enable coverage and the coverage report if it is enabled
type Inspector struct {
	QueryLoader    *QueryLoader
	vb             VulnerabilityBuilder
	tracker        Tracker
	failedQueries  map[string]error
	excludeResults map[string]bool
	detector       *detector.DetectLine

	enableCoverageReport bool
	coverageReport       cover.Report
	queryExecTimeout     time.Duration
	enableGPTIntegration bool
}

// QueryContext contains the context where the query is executed, which scan it belongs, basic information of query,
// the query compiled and its payload
type QueryContext struct {
	Ctx           context.Context
	scanID        string
	Files         map[string]model.FileMetadata
	Query         *PreparedQuery
	payload       *ast.Value
	BaseScanPaths []string
}

var (
	unsafeRegoFunctions = map[string]struct{}{
		"http.send":   {},
		"opa.runtime": {},
	}
)

// NewInspector initializes a inspector, compiling and loading queries for scan and its tracker
func NewInspector(
	ctx context.Context,
	queriesSource source.QueriesSource,
	vb VulnerabilityBuilder,
	tracker Tracker,
	queryParameters *source.QueryInspectorParameters,
	excludeResults map[string]bool,
	queryTimeout int,
	needsLog bool,
	enableGPT bool) (*Inspector, error) {
	log.Debug().Msg("engine.NewInspector()")

	metrics.Metric.Start("get_queries")
	queries, err := queriesSource.GetQueries(queryParameters)
	if err != nil {
		return nil, errors.Wrap(err, "failed to get queries")
	}

	commonLibrary, err := queriesSource.GetQueryLibrary("common")
	if err != nil {
		sentryReport.ReportSentry(&sentryReport.Report{
			Message:  fmt.Sprintf("Inspector failed to get library for %s platform", "common"),
			Err:      err,
			Location: "func NewInspector()",
			Platform: "common",
		}, true)
		return nil, errors.Wrap(err, "failed to get library")
	}
	platformLibraries := getPlatformLibraries(queriesSource, queries)

	queryLoader := prepareQueries(queries, commonLibrary, platformLibraries, tracker)

	failedQueries := make(map[string]error)

	metrics.Metric.Stop()

	if needsLog {
		log.Info().
			Msgf("Inspector initialized, number of queries=%d", queryLoader.querySum)
	}

	lineDetector := detector.NewDetectLine(tracker.GetOutputLines()).
		Add(helm.DetectKindLine{}, model.KindHELM).
		Add(docker.DetectKindLine{}, model.KindDOCKER).
		Add(docker.DetectKindLine{}, model.KindBUILDAH)

	queryExecTimeout := time.Duration(queryTimeout) * time.Second

	if needsLog {
		log.Info().Msgf("Query execution timeout=%v", queryExecTimeout)
	}

	return &Inspector{
		QueryLoader:          &queryLoader,
		vb:                   vb,
		tracker:              tracker,
		failedQueries:        failedQueries,
		excludeResults:       excludeResults,
		detector:             lineDetector,
		queryExecTimeout:     queryExecTimeout,
		enableGPTIntegration: enableGPT,
	}, nil
}

func getPlatformLibraries(queriesSource source.QueriesSource, queries []model.QueryMetadata) map[string]source.RegoLibraries {
	supportedPlatforms := make(map[string]string)
	for _, query := range queries {
		supportedPlatforms[query.Platform] = ""
	}
	platformLibraries := make(map[string]source.RegoLibraries)
	for platform := range supportedPlatforms {
		platformLibrary, errLoadingPlatformLib := queriesSource.GetQueryLibrary(platform)
		if errLoadingPlatformLib != nil {
			sentryReport.ReportSentry(&sentryReport.Report{
				Message:  fmt.Sprintf("Inspector failed to get library for %s platform", platform),
				Err:      errLoadingPlatformLib,
				Location: "func getPlatformLibraries()",
				Platform: platform,
			}, true)
			continue
		}
		platformLibraries[platform] = platformLibrary
	}
	return platformLibraries
}

// Inspect scan files and return the a list of vulnerabilities found on the process
func (c *Inspector) Inspect(
	ctx context.Context,
	scanID string,
	files model.FileMetadatas,
	baseScanPaths []string,
	platforms []string,
	currentQuery chan<- int64) ([]model.Vulnerability, error) {
	log.Debug().Msg("engine.Inspect()")
	combinedFiles := files.Combine(false)

	var vulnerabilities []model.Vulnerability
	vulnerabilities = make([]model.Vulnerability, 0)
	var p interface{}

	payload, err := json.Marshal(combinedFiles)
	if err != nil {
		return vulnerabilities, err
	}

	err = util.UnmarshalJSON(payload, &p)
	if err != nil {
		return vulnerabilities, err
	}

	astPayload, err := ast.InterfaceToValue(p)
	if err != nil {
		return vulnerabilities, err
	}

	if c.enableGPTIntegration {
		log.Debug().Msgf("Starting to run GPT Queries requests")
		aiFoundVulns := c.checkGPTVulnerabilities(ctx, scanID, files, baseScanPaths, platforms)
		vulnerabilities = append(vulnerabilities, aiFoundVulns...)
	}

	queries := c.getQueriesByPlat(platforms)
	for i, queryMeta := range queries {
		currentQuery <- 1

		queryOpa, err := c.QueryLoader.LoadQuery(ctx, &queries[i])
		if err != nil {
			continue
		}

		log.Debug().Msgf("Starting to run query %s", queryMeta.Query)
		queryStartTime := time.Now()

		query := &PreparedQuery{
			OpaQuery: *queryOpa,
			Metadata: queryMeta,
		}

		queryContext := &QueryContext{
			Ctx:           ctx,
			scanID:        scanID,
			Files:         files.ToMap(),
			Query:         query,
			payload:       &astPayload,
			BaseScanPaths: baseScanPaths,
		}

		vuls, err := c.doRun(queryContext)

		if err != nil {
			sentryReport.ReportSentry(&sentryReport.Report{
				Message:  fmt.Sprintf("Inspector. query executed with error, query=%s", query.Metadata.Query),
				Err:      err,
				Location: "func Inspect()",
				Platform: query.Metadata.Platform,
				Metadata: query.Metadata.Metadata,
				Query:    query.Metadata.Query,
			}, true)

			c.failedQueries[query.Metadata.Query] = err

			continue
		}

		log.Debug().Msgf("Finished to run query %s after %v", queryMeta.Query, time.Since(queryStartTime))

		vulnerabilities = append(vulnerabilities, vuls...)

		c.tracker.TrackQueryExecution(query.Metadata.Aggregation)
	}

	return vulnerabilities, nil
}

// LenQueriesByPlat returns the number of queries by platforms
func (c *Inspector) LenQueriesByPlat(platforms []string) int {
	count := 0
	for _, query := range c.QueryLoader.QueriesMetadata {
		if contains(platforms, query.Platform) {
			c.tracker.TrackQueryExecuting(query.Aggregation)
			count++
		}
	}
	return count
}

func (c *Inspector) getQueriesByPlat(platforms []string) []model.QueryMetadata {
	queries := make([]model.QueryMetadata, 0)
	for _, query := range c.QueryLoader.QueriesMetadata {
		if contains(platforms, query.Platform) {
			queries = append(queries, query)
		}
	}
	return queries
}

// EnableCoverageReport enables the flag to create a coverage report
func (c *Inspector) EnableCoverageReport() {
	c.enableCoverageReport = true
}

// GetCoverageReport returns the scan coverage report
func (c *Inspector) GetCoverageReport() cover.Report {
	return c.coverageReport
}

// GetFailedQueries returns a map of failed queries and the associated error
func (c *Inspector) GetFailedQueries() map[string]error {
	return c.failedQueries
}

func (c *Inspector) doRun(ctx *QueryContext) ([]model.Vulnerability, error) {
	timeoutCtx, cancel := context.WithTimeout(ctx.Ctx, c.queryExecTimeout)
	defer cancel()
	options := []rego.EvalOption{rego.EvalParsedInput(*ctx.payload)}

	var cov *cover.Cover
	if c.enableCoverageReport {
		cov = cover.New()
		options = append(options, rego.EvalQueryTracer(cov))
	}

	results, err := ctx.Query.OpaQuery.Eval(timeoutCtx, options...)
	ctx.payload = nil
	if err != nil {
		if topdown.IsCancel(err) {
			return nil, errors.Wrap(err, "query executing timeout exited")
		}

		return nil, errors.Wrap(err, "failed to evaluate query")
	}
	if c.enableCoverageReport && cov != nil {
		module, parseErr := ast.ParseModule(ctx.Query.Metadata.Query, ctx.Query.Metadata.Content)
		if parseErr != nil {
			return nil, errors.Wrap(parseErr, "failed to parse coverage module")
		}

		c.coverageReport = cov.Report(map[string]*ast.Module{
			ctx.Query.Metadata.Query: module,
		})
	}

	log.Trace().
		Str("scanID", ctx.scanID).
		Msgf("Inspector executed with result %+v, query=%s", results, ctx.Query.Metadata.Query)

	return c.DecodeQueryResults(ctx, results)
}

// DecodeQueryResults decodes the results into []model.Vulnerability
func (c *Inspector) DecodeQueryResults(ctx *QueryContext, results rego.ResultSet) ([]model.Vulnerability, error) {
	if len(results) == 0 {
		return nil, ErrNoResult
	}

	result := results[0].Bindings

	queryResult, ok := result["result"]
	if !ok {
		return nil, ErrNoResult
	}

	queryResultItems, ok := queryResult.([]interface{})
	if !ok {
		return nil, ErrInvalidResult
	}

	vulnerabilities := make([]model.Vulnerability, 0, len(queryResultItems))
	failedDetectLine := false
	for _, queryResultItem := range queryResultItems {
		vulnerability, err := c.vb(ctx, c.tracker, queryResultItem, c.detector)
		if err != nil {
			sentryReport.ReportSentry(&sentryReport.Report{
				Message:  fmt.Sprintf("Inspector can't save vulnerability, query=%s", ctx.Query.Metadata.Query),
				Err:      err,
				Location: "func decodeQueryResults()",
				Platform: ctx.Query.Metadata.Platform,
				Metadata: ctx.Query.Metadata.Metadata,
				Query:    ctx.Query.Metadata.Query,
			}, true)

			if _, ok := c.failedQueries[ctx.Query.Metadata.Query]; !ok {
				c.failedQueries[ctx.Query.Metadata.Query] = err
			}

			continue
		}
		file := ctx.Files[vulnerability.FileID]
		if ShouldSkipVulnerability(file.Commands, vulnerability.QueryID) {
			log.Debug().Msgf("Skipping vulnerability in file %s for query '%s':%s", file.FilePath, vulnerability.QueryName, vulnerability.QueryID)
			continue
		}

		if vulnerability.Line == UndetectedVulnerabilityLine {
			failedDetectLine = true
		}

		if _, ok := c.excludeResults[vulnerability.SimilarityID]; ok {
			log.Debug().
				Msgf("Excluding result SimilarityID: %s", vulnerability.SimilarityID)
			continue
		} else if checkComment(vulnerability.Line, file.LinesIgnore) {
			log.Debug().
				Msgf("Excluding result Comment: %s", vulnerability.SimilarityID)
			continue
		}

		vulnerabilities = append(vulnerabilities, *vulnerability)
	}

	if failedDetectLine {
		c.tracker.FailedDetectLine()
	}

	return vulnerabilities, nil
}

// checkComment checks if the vulnerability should be skipped from comment
func checkComment(line int, ignoreLines []int) bool {
	for _, ignoreLine := range ignoreLines {
		if line == ignoreLine {
			return true
		}
	}
	return false
}

// contains is a simple method to check if a slice
// contains an entry
func contains(s []string, e string) bool {
	if e == "common" {
		return true
	}
	if e == "k8s" {
		e = "kubernetes"
	}
	for _, a := range s {
		if strings.EqualFold(a, e) {
			return true
		}
	}
	return false
}

func isDisabled(queries, queryID string, output bool) bool {
	for _, query := range strings.Split(queries, ",") {
		if strings.EqualFold(query, queryID) {
			return output
		}
	}

	return !output
}

// ShouldSkipVulnerability verifies if the vulnerability in question should be ignored through comment commands
func ShouldSkipVulnerability(command model.CommentsCommands, queryID string) bool {
	if queries, ok := command["enable"]; ok {
		return isDisabled(queries, queryID, false)
	}
	if queries, ok := command["disable"]; ok {
		return isDisabled(queries, queryID, true)
	}
	return false
}

func prepareQueries(queries []model.QueryMetadata, commonLibrary source.RegoLibraries,
	platformLibraries map[string]source.RegoLibraries, tracker Tracker) QueryLoader {
	// track queries loaded
	sum := 0
	for _, metadata := range queries {
		tracker.TrackQueryLoad(metadata.Aggregation)
		sum += metadata.Aggregation
	}
	return QueryLoader{
		commonLibrary:     commonLibrary,
		platformLibraries: platformLibraries,
		querySum:          sum,
		QueriesMetadata:   queries,
	}
}

// LoadQuery loads the query into memory so it can be freed when not used anymore
func (q QueryLoader) LoadQuery(ctx context.Context, query *model.QueryMetadata) (*rego.PreparedEvalQuery, error) {
	opaQuery := rego.PreparedEvalQuery{}

	platformGeneralQuery, ok := q.platformLibraries[query.Platform]
	if !ok {
		return nil, errors.New("failed to get platform library")
	}

	select {
	case <-ctx.Done():
		return nil, ctx.Err()
	default:
		mergedInputData, err := source.MergeInputData(platformGeneralQuery.LibraryInputData, query.InputData)
		if err != nil {
			log.Debug().Msgf("Could not merge %s library input data", query.Platform)
		}
		mergedInputData, err = source.MergeInputData(q.commonLibrary.LibraryInputData, mergedInputData)
		if err != nil {
			log.Debug().Msg("Could not merge common library input data")
		}
		store := inmem.NewFromReader(bytes.NewBufferString(mergedInputData))
		opaQuery, err = rego.New(
			rego.Query(regoQuery),
			rego.Module("Common", q.commonLibrary.LibraryCode),
			rego.Module("Generic", platformGeneralQuery.LibraryCode),
			rego.Module(query.Query, query.Content),
			rego.Store(store),
			rego.UnsafeBuiltins(unsafeRegoFunctions),
		).PrepareForEval(ctx)

		if err != nil {
			sentryReport.ReportSentry(&sentryReport.Report{
				Message:  fmt.Sprintf("Inspector failed to prepare query for evaluation, query=%s", query.Query),
				Err:      err,
				Location: "func NewInspector()",
				Query:    query.Query,
				Metadata: query.Metadata,
				Platform: query.Platform,
			}, true)

			return nil, err
		}

		return &opaQuery, nil
	}
}

func (c *Inspector) checkGPTVulnerabilities(
	ctx context.Context,
	scanID string,
	files model.FileMetadatas,
	baseScanPaths []string,
	platforms []string,
) []model.Vulnerability {
	if hasGPTSupportedPlatform(platforms) {
		for _, file := range files {
			aiVulns := make([]model.Vulnerability, 0)
			//queryResultItems := kicsgpt.GetFileEvaluation(file.OriginalData, )
			queryResultItems, err := kicsgpt.GetFileEvaluation(file.OriginalData, file.ID)
			if err != nil {
				log.Debug().Msg("Could not get evaluation from KICS GPT service")
				continue
			}

			queryContext := &QueryContext{
				Ctx:           ctx,
				scanID:        scanID,
				Files:         files.ToMap(),
				Query:         nil,
				payload:       nil,
				BaseScanPaths: baseScanPaths,
			}

			switch reflect.TypeOf(queryResultItems).Kind() {
			case reflect.Slice:
				v := reflect.ValueOf(queryResultItems)

				for i := 0; i < v.Len(); i++ {
					value := v.Index(i).Interface().(map[string]interface{})
					if value != nil {
						queryContext.Query = &PreparedQuery{
							Metadata: model.QueryMetadata{
								Metadata: getGPTQueryMetadata(value),
							},
						}

						vulnerability, err := c.vb(queryContext, c.tracker, value, c.detector)
						codeLines := value["codeLines"].([]int)
						for _, lineVal := range codeLines {
							vulnerability.Line = lineVal
							vulnerability.VulnLines = getVulnLines(lineVal, c.tracker.GetOutputLines(), *file.LinesOriginalData)
							aiVulns = append(aiVulns, *vulnerability)
						}
						if err != nil {
							log.Debug().Msg("Could not use vulnerability builder for result from KICS GPT service")
							continue
						}
					}

				}
			}
			return aiVulns
		}
	}
	return make([]model.Vulnerability, 0)
}

func hasGPTSupportedPlatform(platforms []string) bool {
	for _, a := range platforms {
		if strings.EqualFold(a, "kicsgpt") || strings.EqualFold(a, "ansible") {
			return true
		}
	}
	return false
}

func getGPTQueryMetadata(vuln map[string]interface{}) map[string]interface{} {

	return map[string]interface{}{
		"queryName":       vuln["queryName"].(string),
		"descriptionText": vuln["descriptionText"].(string),
		"platform":        vuln["platform"].(string),
		"descriptionID":   vuln["descriptionID"].(string),
		"cloudProvider":   vuln["cloudProvider"].(string),
		"id":              vuln["id"].(string),
		"severity":        vuln["severity"].(string),
		"category":        vuln["category"].(string),
		"descriptionUrl":  vuln["descriptionUrl"].(string),
	}
}

// GetAdjacent finds and returns the lines adjacent to the line containing the vulnerability
func getVulnLines(line int, outputLines int, originalData []string) *[]model.CodeLine {
	return detector.GetAdjacentVulnLines(line-1, outputLines, originalData)
}

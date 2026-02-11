package engine

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"runtime"
	"strings"
	"sync"
	"time"

	consoleHelpers "github.com/Checkmarx/kics/v2/internal/console/helpers"
	"github.com/Checkmarx/kics/v2/internal/metrics"
	sentryReport "github.com/Checkmarx/kics/v2/internal/sentry"
	"github.com/Checkmarx/kics/v2/pkg/detector"
	"github.com/Checkmarx/kics/v2/pkg/detector/docker"
	"github.com/Checkmarx/kics/v2/pkg/detector/helm"
	"github.com/Checkmarx/kics/v2/pkg/engine/source"
	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/Checkmarx/kics/v2/pkg/utils"

	"github.com/open-policy-agent/opa/v1/ast"
	"github.com/open-policy-agent/opa/v1/cover"
	"github.com/open-policy-agent/opa/v1/rego"
	"github.com/open-policy-agent/opa/v1/storage/inmem"
	"github.com/open-policy-agent/opa/v1/topdown"
	"github.com/open-policy-agent/opa/v1/util"
	"github.com/pkg/errors"
	"github.com/rs/zerolog/log"
	"gopkg.in/yaml.v3"
)

// Default values for inspector
const (
	UndetectedVulnerabilityLine = -1
	DefaultQueryID              = "Undefined"
	DefaultQueryName            = "Anonymous"
	DefaultExperimental         = false
	DefaultQueryDescription     = "Undefined"
	DefaultQueryDescriptionID   = "Undefined"
	DefaultQueryURI             = "https://github.com/Checkmarx/kics/"
	DefaultIssueType            = model.IssueTypeIncorrectValue

	regoQuery = `result = data.Cx.CxPolicy`
	// TransitionInformationBasePath the path to yaml files that contains the transition information
	TransitionInformationBasePath = "./assets/similarityID_transition"
	kubernetesPlatformName        = "kubernetes"
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
	detector *detector.DetectLine, useOldSeverities bool, kicsComputeNewSimID bool,
	similarityIDTransitionQueryMap map[string]TransitionQueryInfo) (*model.Vulnerability, error)

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

	enableCoverageReport      bool
	coverageReport            cover.Report
	queryExecTimeout          time.Duration
	useOldSeverities          bool
	numWorkers                int
	kicsComputeNewSimID       bool
	similarityIDTransitionMap map[string]TransitionQueryInfo
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

func adjustNumWorkers(workers int) int {
	// for the case in which the end user decides to use num workers as "auto-detected"
	// we will set the number of workers to the number of CPUs available based on GOMAXPROCS value
	if workers == 0 {
		return runtime.GOMAXPROCS(-1)
	}
	return workers
}

// NewInspector initializes a inspector, compiling and loading queries for scan and its tracker
func NewInspector(
	ctx context.Context,
	queriesSource source.QueriesSource,
	vb VulnerabilityBuilder,
	tracker Tracker,
	queryParameters *source.QueryInspectorParameters,
	excludeResults map[string]bool,
	queryTimeout int,
	useOldSeverities bool,
	needsLog bool,
	numWorkers int,
	kicsComputeNewSimID bool) (*Inspector, error) {
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

	similarityIDTransitionPath, errSimilarityIDTransitionPath := consoleHelpers.GetDefaultQueryPath(TransitionInformationBasePath)
	if errSimilarityIDTransitionPath != nil {
		log.Warn().Msg("Unable to find transition information files, similarity ID transitions will not be available")
	}
	similarityIDTransitionQueryMap := getSimilarityIDTransitionQueryMap(similarityIDTransitionPath)

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
		QueryLoader:               &queryLoader,
		vb:                        vb,
		tracker:                   tracker,
		failedQueries:             failedQueries,
		excludeResults:            excludeResults,
		detector:                  lineDetector,
		queryExecTimeout:          queryExecTimeout,
		useOldSeverities:          useOldSeverities,
		numWorkers:                adjustNumWorkers(numWorkers),
		kicsComputeNewSimID:       kicsComputeNewSimID,
		similarityIDTransitionMap: similarityIDTransitionQueryMap,
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

// getSimilarityIDTransitionQueryMap gets the map of similarity ID transition queries from the assets
func getSimilarityIDTransitionQueryMap(informationPath string) map[string]TransitionQueryInfo {
	var transitionQueryMap = make(map[string]TransitionQueryInfo)
	err := filepath.WalkDir(informationPath, func(path string, d os.DirEntry, err error) error {
		var changeList = TransitionQueryInfoChangeList{}
		if err != nil {
			log.Error().Msgf("Error walking through transition information files: %v", err)
			return err
		}

		if filepath.Ext(d.Name()) == ".yaml" || filepath.Ext(d.Name()) == ".yml" {
			content, err := os.ReadFile(filepath.Clean(path))
			if err != nil {
				log.Error().Msgf("Error reading transition information file %s", d.Name())
				return err
			}

			err = yaml.Unmarshal(content, &changeList)
			if err != nil {
				log.Error().Msgf("Error unmarshalling transition information file %s: %v", d.Name(), err)
				return err
			}

			for _, change := range changeList.SimilarityIDChangeList {
				if _, ok := transitionQueryMap[change.QueryID]; ok {
					log.Warn().Msgf(
						"Duplicate query ID found in transition information file %s: %s", d.Name(), change.QueryID)
				} else {
					transitionQueryMap[change.QueryID] = change
				}
			}
		}
		return nil
	})
	if err != nil {
		log.Error().Msgf("Error getting similarity ID transition query map: %v", err)
		return nil
	}
	return transitionQueryMap
}

type InspectionJob struct {
	queryID int
}

type QueryResult struct {
	vulnerabilities []model.Vulnerability
	err             error
	queryID         int
}

// This function creates an inspection task and sends it to the jobs channel
func (c *Inspector) createInspectionJobs(jobs chan<- InspectionJob, queries []model.QueryMetadata) {
	defer close(jobs)
	for i := range queries {
		jobs <- InspectionJob{queryID: i}
	}
}

// This function performs an inspection job and sends the result to the results channel
func (c *Inspector) performInspection(ctx context.Context, scanID string, files model.FileMetadatas,
	astPayload ast.Value, baseScanPaths []string, currentQuery chan<- int64,
	jobs <-chan InspectionJob, results chan<- QueryResult, queries []model.QueryMetadata) {
	for job := range jobs {
		currentQuery <- 1

		queryOpa, err := c.QueryLoader.LoadQuery(ctx, &queries[job.queryID])
		if err != nil {
			continue
		}

		log.Debug().Msgf("Starting to run query %s", queries[job.queryID].Query)
		queryStartTime := time.Now()

		query := &PreparedQuery{
			OpaQuery: *queryOpa,
			Metadata: queries[job.queryID],
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
		if err == nil {
			log.Debug().Msgf("Finished to run query %s after %v", queries[job.queryID].Query, time.Since(queryStartTime))
			c.tracker.TrackQueryExecution(query.Metadata.Aggregation)
		}
		results <- QueryResult{vulnerabilities: vuls, err: err, queryID: job.queryID}
	}
}

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

	queries := c.getQueriesByPlat(platforms)

	// Create a channel to collect the results
	results := make(chan QueryResult, len(queries))

	// Create a channel for inspection jobs
	jobs := make(chan InspectionJob, len(queries))

	var wg sync.WaitGroup

	// Start a goroutine for each worker
	for w := 0; w < c.numWorkers; w++ {
		wg.Add(1)

		go func() {
			// Decrement the counter when the goroutine completes
			defer wg.Done()
			c.performInspection(ctx, scanID, files, astPayload, baseScanPaths, currentQuery, jobs, results, queries)
		}()
	}
	// Start a goroutine to create inspection jobs
	go c.createInspectionJobs(jobs, queries)

	go func() {
		// Wait for all jobs to finish
		wg.Wait()
		// Then close the results channel
		close(results)
	}()

	// Collect all the results
	for result := range results {
		if result.err != nil {
			fmt.Println()
			sentryReport.ReportSentry(&sentryReport.Report{
				Message:  fmt.Sprintf("Inspector. query executed with error, query=%s", queries[result.queryID].Query),
				Err:      result.err,
				Location: "func Inspect()",
				Platform: queries[result.queryID].Platform,
				Metadata: queries[result.queryID].Metadata,
				Query:    queries[result.queryID].Query,
			}, true)

			c.failedQueries[queries[result.queryID].Query] = result.err

			continue
		}
		vulnerabilities = append(vulnerabilities, result.vulnerabilities...)
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

func (c *Inspector) doRun(ctx *QueryContext) (vulns []model.Vulnerability, err error) {
	timeoutCtx, cancel := context.WithTimeout(ctx.Ctx, c.queryExecTimeout)
	defer cancel()
	defer func() {
		if r := recover(); r != nil {
			errMessage := fmt.Sprintf("Recovered from panic during query '%s' run. ", ctx.Query.Metadata.Query)
			err = fmt.Errorf("panic: %v", r)
			fmt.Println()
			log.Err(err).Msg(errMessage)
		}
	}()
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
		module, parseErr := ast.ParseModuleWithOpts(
			ctx.Query.Metadata.Query,
			ctx.Query.Metadata.Content,
			ast.ParserOptions{RegoVersion: ast.RegoV0},
		)
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

	timeoutCtxToDecode, cancelDecode := context.WithTimeout(ctx.Ctx, c.queryExecTimeout)
	defer cancelDecode()
	return c.DecodeQueryResults(ctx, timeoutCtxToDecode, results)
}

// DecodeQueryResults decodes the results into []model.Vulnerability
func (c *Inspector) DecodeQueryResults(
	ctx *QueryContext,
	ctxTimeout context.Context,
	results rego.ResultSet) ([]model.Vulnerability, error) {
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
	timeOut := false
	for _, queryResultItem := range queryResultItems {
		select {
		case <-ctxTimeout.Done():
			timeOut = true
		default:
			vulnerability, aux := getVulnerabilitiesFromQuery(ctx, c, queryResultItem)
			if aux {
				failedDetectLine = aux
			}
			if vulnerability != nil && !aux {
				vulnerabilities = append(vulnerabilities, *vulnerability)
			}
		}
	}

	if timeOut {
		fmt.Println()
		log.Err(ctxTimeout.Err()).Msgf(
			"Timeout processing the results of the query: %s %s",
			ctx.Query.Metadata.Platform,
			ctx.Query.Metadata.Query)
	}

	if failedDetectLine {
		c.tracker.FailedDetectLine()
	}

	filterOutDuplicatedHelmVulnerabilities(&vulnerabilities)
	return vulnerabilities, nil
}

func filterOutDuplicatedHelmVulnerabilities(vulnerabilities *[]model.Vulnerability) *[]model.Vulnerability {
	vulnerabilityMap := map[string][]model.Vulnerability{}
	// map K8s results
	for i := 0; i < len(*vulnerabilities); i++ {
		if strings.EqualFold((*vulnerabilities)[i].Platform, kubernetesPlatformName) {
			utils.SafeAddToSliceMap(vulnerabilityMap, (*vulnerabilities)[i].SimilarityID, (*vulnerabilities)[i])
			if len(vulnerabilityMap[(*vulnerabilities)[i].SimilarityID]) > 2 {
				log.Warn().Msgf("Multiple duplicated vulnerability found for: SimilarityID=%s QueryID=%s",
					(*vulnerabilities)[i].SimilarityID, (*vulnerabilities)[i].QueryID)
			}
		}
	}

	// filter out duplicated K8s results from slice
	filtered := make([]model.Vulnerability, 0, len(*vulnerabilities))
	for i := 0; i < len(*vulnerabilities); i++ {
		// Keep vulnerability if it's NOT a duplicated Helm K8s result
		if !strings.EqualFold((*vulnerabilities)[i].Platform, kubernetesPlatformName) || (*vulnerabilities)[i].FileKind != model.KindHELM ||
			len(vulnerabilityMap[(*vulnerabilities)[i].SimilarityID]) <= 1 {
			filtered = append(filtered, (*vulnerabilities)[i])
		}
	}

	*vulnerabilities = filtered
	return vulnerabilities
}

func getVulnerabilitiesFromQuery(ctx *QueryContext, c *Inspector, queryResultItem interface{}) (*model.Vulnerability, bool) {
	vulnerability, err := c.vb(ctx, c.tracker, queryResultItem, c.detector,
		c.useOldSeverities, c.kicsComputeNewSimID, c.similarityIDTransitionMap)
	if err != nil && err.Error() == ErrNoResult.Error() {
		// Ignoring bad results
		return nil, false
	}
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

		return nil, false
	}
	file := ctx.Files[vulnerability.FileID]
	if ShouldSkipVulnerability(file.Commands, vulnerability.QueryID) {
		log.Debug().Msgf("Skipping vulnerability in file %s for query '%s':%s", file.FilePath, vulnerability.QueryName, vulnerability.QueryID)
		return nil, false
	}

	if vulnerability.Line == UndetectedVulnerabilityLine {
		return nil, true
	}

	if _, ok := c.excludeResults[vulnerability.SimilarityID]; ok {
		log.Debug().
			Msgf("Excluding result SimilarityID: %s", vulnerability.SimilarityID)
		return nil, false
	} else if checkComment(vulnerability.Line, file.LinesIgnore) {
		log.Debug().
			Msgf("Excluding result Comment: %s", vulnerability.SimilarityID)
		return nil, false
	}

	return vulnerability, false
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
			rego.SetRegoVersion(ast.RegoV0),
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

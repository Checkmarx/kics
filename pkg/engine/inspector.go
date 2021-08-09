package engine

import (
	"bytes"
	"context"
	"encoding/json"
	"strings"
	"time"

	"github.com/Checkmarx/kics/internal/metrics"
	"github.com/Checkmarx/kics/pkg/detector"
	"github.com/Checkmarx/kics/pkg/detector/docker"
	"github.com/Checkmarx/kics/pkg/detector/helm"
	"github.com/Checkmarx/kics/pkg/engine/source"
	"github.com/Checkmarx/kics/pkg/model"
	"github.com/getsentry/sentry-go"
	"github.com/open-policy-agent/opa/ast"
	"github.com/open-policy-agent/opa/cover"
	"github.com/open-policy-agent/opa/rego"
	"github.com/open-policy-agent/opa/storage/inmem"
	"github.com/open-policy-agent/opa/topdown"
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

// VulnerabilityBuilder represents a function that will build a vulnerability
type VulnerabilityBuilder func(ctx *QueryContext, tracker Tracker, v interface{},
	detector *detector.DetectLine) (model.Vulnerability, error)

// Tracker wraps an interface that contain basic methods: TrackQueryLoad, TrackQueryExecution and FailedDetectLine
// TrackQueryLoad increments the number of loaded queries
// TrackQueryExecution increments the number of queries executed
// FailedDetectLine decrements the number of queries executed
// GetOutputLines returns the number of lines to be displayed in results outputs
type Tracker interface {
	TrackQueryLoad(queryAggregation int)
	TrackQueryExecuting(queryAggregation int)
	TrackQueryExecution(queryAggregation int)
	FailedDetectLine()
	FailedComputeSimilarityID()
	GetOutputLines() int
}

type preparedQuery struct {
	opaQuery rego.PreparedEvalQuery
	metadata model.QueryMetadata
}

// Inspector represents a list of compiled queries, a builder for vulnerabilities, an information tracker
// a flag to enable coverage and the coverage report if it is enabled
type Inspector struct {
	queries        []*preparedQuery
	vb             VulnerabilityBuilder
	tracker        Tracker
	failedQueries  map[string]error
	excludeResults map[string]bool
	detector       *detector.DetectLine

	enableCoverageReport bool
	coverageReport       cover.Report
	queryExecTimeout     time.Duration
}

// QueryContext contains the context where the query is executed, which scan it belongs, basic information of query,
// the query compiled and its payload
type QueryContext struct {
	ctx           context.Context
	scanID        string
	files         map[string]model.FileMetadata
	query         *preparedQuery
	payload       model.Documents
	baseScanPaths []string
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
	queryTimeout int) (*Inspector, error) {
	log.Debug().Msg("engine.NewInspector()")

	metrics.Metric.Start("get_queries")
	queries, err := queriesSource.GetQueries(queryParameters)
	if err != nil {
		return nil, errors.Wrap(err, "failed to get queries")
	}

	commonGeneralQuery, err := queriesSource.GetQueryLibrary("common")
	if err != nil {
		sentry.CaptureException(err)
		log.Err(err).
			Msgf("Inspector failed to get general query, query=%s", "common")
	}
	opaQueries := make([]*preparedQuery, 0, len(queries))
	for _, metadata := range queries {
		platformGeneralQuery, err := queriesSource.GetQueryLibrary(metadata.Platform)
		if err != nil {
			sentry.CaptureException(err)
			log.Err(err).
				Msgf("Inspector failed to get generic query, query=%s", metadata.Query)

			continue
		}

		select {
		case <-ctx.Done():
			return nil, nil
		default:
			var opaQuery rego.PreparedEvalQuery
			store := inmem.NewFromReader(bytes.NewBufferString(metadata.InputData))
			opaQuery, err = rego.New(
				rego.Query(regoQuery),
				rego.Module("Common", commonGeneralQuery),
				rego.Module("Generic", platformGeneralQuery),
				rego.Module(metadata.Query, metadata.Content),
				rego.Store(store),
				rego.UnsafeBuiltins(unsafeRegoFunctions),
			).PrepareForEval(ctx)
			if err != nil {
				sentry.CaptureException(err)
				log.Err(err).
					Msgf("Inspector failed to prepare query for evaluation, query=%s", metadata.Query)

				continue
			}

			tracker.TrackQueryLoad(metadata.Aggregation)

			opaQueries = append(opaQueries, &preparedQuery{
				opaQuery: opaQuery,
				metadata: metadata,
			})
		}
	}

	failedQueries := make(map[string]error)

	queriesNumber := sumAllAggregatedQueries(opaQueries)

	metrics.Metric.Stop()

	log.Info().
		Msgf("Inspector initialized, number of queries=%d", queriesNumber)

	lineDetctor := detector.NewDetectLine(tracker.GetOutputLines()).
		Add(helm.DetectKindLine{}, model.KindHELM).
		Add(docker.DetectKindLine{}, model.KindDOCKER)

	queryExecTimeout := time.Duration(queryTimeout) * time.Second
	log.Info().Msgf("Query execution timeout=%v", queryExecTimeout)

	return &Inspector{
		queries:          opaQueries,
		vb:               vb,
		tracker:          tracker,
		failedQueries:    failedQueries,
		excludeResults:   excludeResults,
		detector:         lineDetctor,
		queryExecTimeout: queryExecTimeout,
	}, nil
}

func sumAllAggregatedQueries(opaQueries []*preparedQuery) int {
	sum := 0
	for _, query := range opaQueries {
		sum += query.metadata.Aggregation
	}
	return sum
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
	combinedFiles := files.Combine()

	_, err := json.Marshal(combinedFiles)
	if err != nil {
		return nil, err
	}

	var vulnerabilities []model.Vulnerability
	vulnerabilities = make([]model.Vulnerability, 0)
	for _, query := range c.getQueriesByPlat(platforms) {
		currentQuery <- 1

		vuls, err := c.doRun(&QueryContext{
			ctx:           ctx,
			scanID:        scanID,
			files:         files.ToMap(),
			query:         query,
			payload:       combinedFiles,
			baseScanPaths: baseScanPaths,
		})
		if err != nil {
			sentry.CaptureException(err)
			log.Err(err).
				Str("scanID", scanID).
				Msgf("Inspector. query executed with error, query=%s", query.metadata.Query)

			c.failedQueries[query.metadata.Query] = err

			continue
		}

		vulnerabilities = append(vulnerabilities, vuls...)

		c.tracker.TrackQueryExecution(query.metadata.Aggregation)
	}

	return vulnerabilities, nil
}

// LenQueriesByPlat returns the number of queries by platforms
func (c *Inspector) LenQueriesByPlat(platforms []string) int {
	count := 0
	for _, query := range c.queries {
		if contains(platforms, query.metadata.Platform) {
			c.tracker.TrackQueryExecuting(query.metadata.Aggregation)
			count++
		}
	}
	return count
}

func (c *Inspector) getQueriesByPlat(platforms []string) []*preparedQuery {
	queries := make([]*preparedQuery, 0)
	for _, query := range c.queries {
		if contains(platforms, query.metadata.Platform) {
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
	timeoutCtx, cancel := context.WithTimeout(ctx.ctx, c.queryExecTimeout)
	defer cancel()

	options := []rego.EvalOption{rego.EvalInput(ctx.payload)}

	var cov *cover.Cover
	if c.enableCoverageReport {
		cov = cover.New()
		options = append(options, rego.EvalQueryTracer(cov))
	}

	results, err := ctx.query.opaQuery.Eval(timeoutCtx, options...)
	if err != nil {
		if topdown.IsCancel(err) {
			return nil, errors.Wrap(err, "query executing timeout exited")
		}

		return nil, errors.Wrap(err, "failed to evaluate query")
	}
	if c.enableCoverageReport && cov != nil {
		module, parseErr := ast.ParseModule(ctx.query.metadata.Query, ctx.query.metadata.Content)
		if parseErr != nil {
			return nil, errors.Wrap(parseErr, "failed to parse coverage module")
		}

		c.coverageReport = cov.Report(map[string]*ast.Module{
			ctx.query.metadata.Query: module,
		})
	}

	log.Trace().
		Str("scanID", ctx.scanID).
		Msgf("Inspector executed with result %+v, query=%s", results, ctx.query.metadata.Query)

	return c.decodeQueryResults(ctx, results)
}

func (c *Inspector) decodeQueryResults(ctx *QueryContext, results rego.ResultSet) ([]model.Vulnerability, error) {
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
			sentry.CaptureException(err)
			log.Err(err).
				Msgf("Inspector can't save vulnerability, query=%s", ctx.query.metadata.Query)

			if _, ok := c.failedQueries[ctx.query.metadata.Query]; !ok {
				c.failedQueries[ctx.query.metadata.Query] = err
			}

			continue
		}

		if vulnerability.Line == UndetectedVulnerabilityLine {
			failedDetectLine = true
		}

		if _, ok := c.excludeResults[vulnerability.SimilarityID]; ok {
			log.Debug().
				Msgf("Excluding result SimilarityID: %s", vulnerability.SimilarityID)
		} else {
			vulnerabilities = append(vulnerabilities, vulnerability)
		}
	}

	if failedDetectLine {
		c.tracker.FailedDetectLine()
	}

	return vulnerabilities, nil
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

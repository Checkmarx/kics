package engine

import (
	"context"
	"encoding/json"
	"time"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/getsentry/sentry-go"
	"github.com/open-policy-agent/opa/ast"
	"github.com/open-policy-agent/opa/cover"
	"github.com/open-policy-agent/opa/rego"
	"github.com/open-policy-agent/opa/topdown"
	"github.com/pkg/errors"
	"github.com/rs/zerolog/log"
)

const (
	UndetectedVulnerabilityLine = 1
	DefaultQueryID              = "Undefined"
	DefaultQueryName            = "Anonymous"
	DefaultIssueType            = model.IssueTypeIncorrectValue

	regoQuery      = `result = data.Cx.CxPolicy`
	executeTimeout = 3 * time.Second
)

var ErrNoResult = errors.New("query: not result")
var ErrInvalidResult = errors.New("query: invalid result format")

type VulnerabilityBuilder func(ctx QueryContext, v interface{}) (model.Vulnerability, error)

type QueriesSource interface {
	GetQueries() ([]model.QueryMetadata, error)
}

type Tracker interface {
	TrackQueryLoad()
	TrackQueryExecution()
}

type preparedQuery struct {
	opaQuery rego.PreparedEvalQuery
	metadata model.QueryMetadata
}

type Inspector struct {
	queries []*preparedQuery
	vb      VulnerabilityBuilder
	tracker Tracker

	enableCoverageReport bool
	coverageReport       cover.Report
}

type QueryContext struct {
	ctx     context.Context
	scanID  string
	files   map[string]model.FileMetadata
	query   *preparedQuery
	payload model.Documents
}

var (
	unsafeRegoFunctions = map[string]struct{}{
		"http.send":   {},
		"opa.runtime": {},
	}
)

func NewInspector(
	ctx context.Context,
	source QueriesSource,
	vb VulnerabilityBuilder,
	tracker Tracker,
) (*Inspector, error) {
	queries, err := source.GetQueries()
	if err != nil {
		return nil, errors.Wrap(err, "failed to get queries")
	}

	opaQueries := make([]*preparedQuery, 0, len(queries))
	for _, metadata := range queries {
		select {
		case <-ctx.Done():
			return nil, nil
		default:
			opaQuery, err := rego.New(
				rego.Query(regoQuery),
				rego.Module(metadata.Query, metadata.Content),
				rego.UnsafeBuiltins(unsafeRegoFunctions),
			).PrepareForEval(ctx)
			if err != nil {
				sentry.CaptureException(err)
				log.
					Err(err).
					Msgf("Inspector failed to prepare query for evaluation, query=%s", metadata.Query)

				continue
			}

			tracker.TrackQueryLoad()

			opaQueries = append(opaQueries, &preparedQuery{
				opaQuery: opaQuery,
				metadata: metadata,
			})
		}
	}

	log.Info().
		Msgf("Inspector initialized, number of queries=%d\n", len(opaQueries))

	return &Inspector{
		queries: opaQueries,
		vb:      vb,
		tracker: tracker,
	}, nil
}

func (c *Inspector) Inspect(ctx context.Context, scanID string, files model.FileMetadatas) ([]model.Vulnerability, error) {
	combinedFiles := files.Combine()

	_, err := json.Marshal(combinedFiles)
	if err != nil {
		return nil, err
	}

	var vulnerabilities []model.Vulnerability
	for _, query := range c.queries {
		vuls, err := c.doRun(QueryContext{
			ctx:     ctx,
			scanID:  scanID,
			files:   files.ToMap(),
			query:   query,
			payload: combinedFiles,
		})
		if err != nil {
			sentry.CaptureException(err)
			log.Err(err).
				Str("scanID", scanID).
				Msgf("inspector. query executed with error, query=%s", query.metadata.Query)

			continue
		}

		vulnerabilities = append(vulnerabilities, vuls...)

		c.tracker.TrackQueryExecution()
	}

	return vulnerabilities, nil
}

func (c *Inspector) EnableCoverageReport() {
	c.enableCoverageReport = true
}

func (c *Inspector) GetCoverageReport() cover.Report {
	return c.coverageReport
}

func (c *Inspector) doRun(ctx QueryContext) ([]model.Vulnerability, error) {
	timeoutCtx, cancel := context.WithTimeout(ctx.ctx, executeTimeout)
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

func (c *Inspector) decodeQueryResults(ctx QueryContext, results rego.ResultSet) ([]model.Vulnerability, error) {
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
	for _, queryResultItem := range queryResultItems {
		vulnerability, err := c.vb(ctx, queryResultItem)
		if err != nil {
			sentry.CaptureException(err)
			log.Err(err).
				Msgf("Inspector can't save vulnerability, query=%s", ctx.query.metadata.Query)

			continue
		}

		vulnerabilities = append(vulnerabilities, vulnerability)
	}

	return vulnerabilities, nil
}

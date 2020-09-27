package engine

import (
	"context"
	"encoding/json"
	"time"

	"github.com/checkmarxDev/ice/internal/logger"
	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/open-policy-agent/opa/ast"
	"github.com/open-policy-agent/opa/rego"
	"github.com/open-policy-agent/opa/topdown"
	"github.com/open-policy-agent/opa/types"
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

type FilesStorage interface {
	GetFiles(ctx context.Context, scanID, filter string) (model.FileMetadatas, error)
	SaveVulnerabilities(ctx context.Context, vulnerabilities []model.Vulnerability) error
}

type preparedQuery struct {
	opaQuery rego.PreparedEvalQuery
	metadata model.QueryMetadata
}

type Inspector struct {
	queries []*preparedQuery
	storage FilesStorage
	vb      VulnerabilityBuilder
}

type QueryContext struct {
	ctx    context.Context
	scanID string
	files  map[string]model.FileMetadata
	query  *preparedQuery
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
	storage FilesStorage,
	vb VulnerabilityBuilder,
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
				rego.Module(metadata.FileName, metadata.Content),
				rego.UnsafeBuiltins(unsafeRegoFunctions),
				rego.Function1(
					&rego.Function{
						Name:    "mergeWithMetadata",
						Decl:    types.NewFunction(types.Args(types.A), types.A),
						Memoize: false,
					},
					func(query model.QueryMetadata) rego.Builtin1 {
						return func(_ rego.BuiltinContext, a *ast.Term) (*ast.Term, error) {
							var value map[string]interface{}
							if err := ast.As(a.Value, &value); err != nil {
								return nil, err
							}

							for k, v := range query.Metadata {
								value[k] = v
							}

							v, err := ast.InterfaceToValue(value)
							if err != nil {
								return nil, err
							}

							return ast.NewTerm(v), nil
						}
					}(metadata),
				),
			).PrepareForEval(ctx)
			if err != nil {
				log.
					Err(err).
					Str("fileName", metadata.FileName).
					Msgf("failed to prepare query for evaluation: %s", metadata.FileName)

				continue
			}

			opaQueries = append(opaQueries, &preparedQuery{
				opaQuery: opaQuery,
				metadata: metadata,
			})
		}
	}

	log.Info().
		Msgf("Inspector initialized with %d queries", len(opaQueries))

	return &Inspector{
		queries: opaQueries,
		storage: storage,
		vb:      vb,
	}, nil
}

func (c *Inspector) Inspect(ctx context.Context, scanID string) error {
	for _, query := range c.queries {
		files, err := c.storage.GetFiles(ctx, scanID, query.metadata.Filter)
		if err != nil {
			return errors.Wrap(err, "failed to query files to query")
		}

		err = c.doRun(ctx, scanID, files, query)
		if err != nil {
			logger.GetLoggerWithFieldsFromContext(ctx).
				Err(err).
				Str("scanID", scanID).
				Msgf("inspector. query %s executed with error", query.metadata.FileName)
		}
	}

	return nil
}

func (c *Inspector) doRun(ctx context.Context, scanID string, files model.FileMetadatas, query *preparedQuery) error {
	filesInJSON, err := files.CombineToJSON()
	if err != nil {
		return errors.Wrap(err, "failed to combine all files to one")
	}

	// parsing JSON into a structured map required for OPA query
	var queryPayload map[string]interface{}
	err = json.Unmarshal([]byte(filesInJSON), &queryPayload)
	if err != nil {
		return errors.Wrap(err, "failed to prepare query results")
	}

	ctx, cancel := context.WithTimeout(ctx, executeTimeout)
	defer cancel()

	results, err := query.opaQuery.Eval(ctx, rego.EvalInput(queryPayload))
	if err != nil {
		if topdown.IsCancel(err) {
			return errors.Wrap(err, "query executing timeout exited")
		}

		return errors.Wrap(err, "failed to evaluate query")
	}

	log.Trace().
		Str("scanID", scanID).
		Str("query", query.metadata.FileName).
		Msgf("execution result %+v", results)

	queryContext := QueryContext{
		ctx:    ctx,
		scanID: scanID,
		files:  files.ToMap(),
		query:  query,
	}

	vulnerabilities, err := c.decodeQueryResults(queryContext, results)
	if err != nil {
		return errors.Wrap(err, "failed to save query result")
	}

	if err := c.storage.SaveVulnerabilities(ctx, vulnerabilities); err != nil {
		return errors.Wrap(err, "failed to save query results")
	}

	return nil
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
			log.Warn().
				Str("reason", err.Error()).
				Str("queryName", ctx.query.metadata.FileName).
				Msg("can't save vulnerability")

			continue
		}

		vulnerabilities = append(vulnerabilities, vulnerability)
	}

	return vulnerabilities, nil
}

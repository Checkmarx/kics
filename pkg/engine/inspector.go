package engine

import (
	"bufio"
	"context"
	"encoding/json"
	"fmt"
	"regexp"
	"strconv"
	"strings"
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
	DefaultQueryName            = "Anonymous"
	DefaultIssueType            = model.IssueTypeIncorrectValue

	regoQuery      = `result = data.Cx.CxPolicy`
	executeTimeout = 3 * time.Second
)

var ErrNoResult = errors.New("query: not result")
var ErrInvalidResult = errors.New("query: invalid result format")

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
}

type QueryContext struct {
	ctx    context.Context
	scanID string
	files  map[string]model.FileMetadata
	query  *preparedQuery
}

var (
	nameRegex           = regexp.MustCompile(`^([A-Za-z0-9-_]+)\[([A-Za-z0-9-_]+)]$`)
	unsafeRegoFunctions = map[string]struct{}{
		"http.send":   {},
		"opa.runtime": {},
	}
)

func NewInspector(ctx context.Context, source QueriesSource, storage FilesStorage) (*Inspector, error) {
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

	if err := c.saveResultIfExists(queryContext, results); err != nil {
		return errors.Wrap(err, "failed to save query result")
	}

	return nil
}

func (c *Inspector) saveResultIfExists(ctx QueryContext, results rego.ResultSet) error {
	if len(results) == 0 {
		return ErrNoResult
	}

	result := results[0].Bindings

	queryResult, ok := result["result"]
	if !ok {
		return ErrNoResult
	}

	queryResultItems, ok := queryResult.([]interface{})
	if !ok {
		return ErrInvalidResult
	}

	vulnerabilities := make([]model.Vulnerability, 0, len(queryResultItems))
	for _, queryResultItem := range queryResultItems {
		vulnerability, err := buildVulnerability(ctx, queryResultItem)
		if err != nil {
			log.Warn().
				Str("reason", err.Error()).
				Str("queryName", ctx.query.metadata.FileName).
				Msg("can't save vulnerability")

			continue
		}

		vulnerabilities = append(vulnerabilities, vulnerability)
	}

	if err := c.storage.SaveVulnerabilities(ctx.ctx, vulnerabilities); err != nil {
		return errors.Wrap(err, "failed to save query results")
	}

	return nil
}

func buildVulnerability(ctx QueryContext, v interface{}) (model.Vulnerability, error) {
	vOjb, ok := v.(map[string]interface{})
	if !ok {
		return model.Vulnerability{}, ErrInvalidResult
	}

	output, err := json.Marshal(vOjb)
	if err != nil {
		return model.Vulnerability{}, errors.Wrap(err, "failed to marshall query output")
	}

	fileID, err := mapKeyToString(ctx, vOjb, "documentId", false)
	if err != nil {
		return model.Vulnerability{}, errors.Wrap(err, "failed to recognize file id")
	}

	file, ok := ctx.files[*fileID]
	if !ok {
		return model.Vulnerability{}, errors.New("failed to find file from query response")
	}

	logWithFields := log.With().
		Str("scanID", ctx.scanID).
		Int("fileID", file.ID).
		Str("queryName", ctx.query.metadata.FileName).
		Logger()

	line := UndetectedVulnerabilityLine
	searchKey := ""
	if s, ok := vOjb["searchKey"]; ok {
		searchKey = s.(string)
		line = detectLine(ctx, &file, searchKey)
	} else {
		logWithFields.Warn().Msg("saving result. failed to detect line")
	}

	queryName := DefaultQueryName
	if qn, err := mapKeyToString(ctx, vOjb, "name", false); err == nil {
		queryName = *qn
	} else {
		logWithFields.Warn().Msg("saving result. failed to detect query name")
	}

	var severity model.Severity = model.SeverityInfo
	if s, err := mapKeyToString(ctx, vOjb, "severity", false); err == nil {
		su := strings.ToUpper(*s)
		var found bool
		for _, si := range model.AllSeverities {
			if su == string(si) {
				severity = si
				found = true
				break
			}
		}

		if !found {
			logWithFields.Warn().Str("severity", *s).Msg("saving result. invalid severity constant value")
		}
	} else {
		logWithFields.Info().Msg("saving result. failed to detect severity")
	}

	issueType := DefaultIssueType
	if v := mustMapKeyToString(ctx, vOjb, "issueType", true); v != nil {
		issueType = model.IssueType(*v)
	}

	return model.Vulnerability{
		ID:               0,
		ScanID:           ctx.scanID,
		FileID:           file.ID,
		QueryName:        queryName,
		Severity:         severity,
		Line:             line,
		IssueType:        issueType,
		SearchKey:        searchKey,
		KeyExpectedValue: mustMapKeyToString(ctx, vOjb, "keyExpectedValue", true),
		KeyActualValue:   mustMapKeyToString(ctx, vOjb, "keyActualValue", true),
		Output:           string(output),
	}, nil
}

func detectLine(ctx QueryContext, file *model.FileMetadata, s string) int {
	logUndetected := func() {
		logger.GetLoggerWithFieldsFromContext(ctx.ctx).
			Warn().
			Str("scanID", ctx.scanID).
			Int("fileID", file.ID).
			Msgf("filed to detect line, query response %s", s)
	}

	scanner := bufio.NewScanner(strings.NewReader(file.OriginalData))
	var (
		line, lastMatchedLine int
		foundAtLeastOne       bool
	)

	keys := strings.Split(s, ".")
	for _, key := range keys {
		var name string
		if parts := nameRegex.FindStringSubmatch(key); len(parts) > 1 {
			key = parts[1]
			name = parts[2]
		}

		for scanner.Scan() {
			line++

			if strings.Contains(scanner.Text(), key) && (name == "" || strings.Contains(scanner.Text(), name)) {
				lastMatchedLine = line
				foundAtLeastOne = true
				break
			}
		}
	}

	if err := scanner.Err(); err != nil {
		logger.GetLoggerWithFieldsFromContext(ctx.ctx).
			Err(err).
			Str("scanID", ctx.scanID).
			Msgf("detecting line. scanner err for file id %d, search %s", file.ID, s)
	}

	if foundAtLeastOne {
		return lastMatchedLine
	}

	logUndetected()
	return UndetectedVulnerabilityLine
}

func mustMapKeyToString(ctx QueryContext, m map[string]interface{}, key string, allowNil bool) *string {
	res, err := mapKeyToString(ctx, m, key, allowNil)
	if err != nil {
		log.Warn().
			Str("reason", err.Error()).
			Msgf("failed to get key %s in map", key)
	}

	return res
}

func mapKeyToString(ctx QueryContext, m map[string]interface{}, key string, allowNil bool) (*string, error) {
	v, ok := m[key]
	if !ok {
		return nil, fmt.Errorf("key '%s' not found in map", key)
	}

	switch vv := v.(type) {
	case json.Number:
		return prtString(vv.String()), nil
	case string:
		return prtString(vv), nil
	case int, int32, int64:
		return prtString(fmt.Sprintf("%d", vv)), nil
	case float32:
		return prtString(strconv.FormatFloat(float64(vv), 'f', -1, 64)), nil
	case float64:
		return prtString(strconv.FormatFloat(vv, 'f', -1, 64)), nil
	case nil:
		if allowNil {
			return nil, nil
		}
		return prtString("null"), nil
	case bool:
		return prtString(fmt.Sprintf("%v", vv)), nil
	}

	logger.GetLoggerWithFieldsFromContext(ctx.ctx).
		Debug().
		Msg("detecting line. can't format item to string")

	if allowNil {
		return nil, nil
	}

	return prtString(""), nil
}

func prtString(v string) *string {
	return &v
}

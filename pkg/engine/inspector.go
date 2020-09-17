package engine

import (
	"bufio"
	"context"
	"encoding/json"
	"fmt"
	"strings"

	"github.com/checkmarxDev/ice/internal/logger"
	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/open-policy-agent/opa/rego"
	"github.com/pkg/errors"
	"github.com/rs/zerolog/log"
)

const (
	UndetectedVulnerabilityLine = 1
	DefaultQueryName            = "Anonymous"
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

const query = `result = data.Cx.CxPolicy`

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
			opaQuery, err := rego.New(rego.Query(query), rego.Module(metadata.FileName, metadata.Content)).PrepareForEval(ctx)
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

	filesInMap := files.ToMap()

	// parsing JSON into a structured map required for OPA query
	var inMap map[string]interface{}
	err = json.Unmarshal([]byte(filesInJSON), &inMap)
	if err != nil {
		return errors.Wrap(err, "failed to prepare query results")
	}

	results, err := query.opaQuery.Eval(ctx, rego.EvalInput(inMap))
	if err != nil {
		return errors.Wrap(err, "failed to evaluate query")
	}

	log.Trace().
		Str("scanID", scanID).
		Str("query", query.metadata.FileName).
		Msgf("execution result %+v", results)

	if len(results) == 0 {
		return ErrNoResult
	}

	if err := c.saveResultIfExists(ctx, scanID, query, results[0].Bindings, filesInMap); err != nil {
		return errors.Wrap(err, "failed to save query result")
	}

	return nil
}

func (c *Inspector) saveResultIfExists(
	ctx context.Context,
	scanID string,
	query *preparedQuery,
	vars rego.Vars,
	filesInMap map[string]model.FileMetadata,
) error { // nolint:lll
	v, ok := vars["result"]
	if !ok {
		return ErrNoResult
	}

	vList, ok := v.([]interface{})
	if !ok {
		return ErrInvalidResult
	}

	results := make([]model.Vulnerability, 0, len(vList))
	for _, vListItem := range vList {
		vOjb, ok := vListItem.(map[string]interface{})
		if !ok {
			return ErrInvalidResult
		}

		output, err := json.Marshal(vOjb)
		if err != nil {
			return errors.Wrap(err, "failed to marshall query output")
		}

		fileID, err := mapKeyToString(ctx, vOjb, "fileId")
		if err != nil {
			return errors.Wrap(err, "failed to recognize file id")
		}

		file, ok := filesInMap[fileID]
		if !ok {
			return errors.New("failed to find file from query response")
		}

		logWithFields := log.With().
			Str("scanID", scanID).
			Int("fileID", file.ID).
			Str("queryName", query.metadata.FileName).
			Logger()

		line := UndetectedVulnerabilityLine
		if searchInfo, ok := vOjb["lineSearchKey"]; ok {
			line = c.detectLine(ctx, scanID, &file, searchInfo)
		} else {
			logWithFields.Info().Msg("saving result. failed to detect line")
		}

		queryName := DefaultQueryName
		if qn, err := mapKeyToString(ctx, vOjb, "name"); err == nil {
			queryName = qn
		} else {
			logWithFields.Info().Msg("saving result. failed to detect query name")
		}

		var severity model.Severity = model.SeverityInfo
		if s, err := mapKeyToString(ctx, vOjb, "severity"); err == nil {
			s = strings.ToUpper(s)
			var found bool
			for _, si := range model.AllSeverities {
				if s == string(si) {
					severity = si
					found = true
					break
				}
			}

			if !found {
				logWithFields.Info().Str("severity", s).Msg("saving result. invalid severity constant value")
			}
		} else {
			logWithFields.Info().Msg("saving result. failed to detect severity")
		}

		results = append(results, model.Vulnerability{
			FileID:    file.ID,
			ScanID:    scanID,
			QueryName: queryName,
			Severity:  severity,
			Line:      line,
			Output:    string(output),
		})
	}

	if err := c.storage.SaveVulnerabilities(ctx, results); err != nil {
		return errors.Wrap(err, "failed to save query results")
	}

	return nil
}

func (c *Inspector) detectLine(ctx context.Context, scanID string, file *model.FileMetadata, i interface{}) int {
	scanner := bufio.NewScanner(strings.NewReader(file.OriginalData))
	line := 1

	switch v := i.(type) {
	case []interface{}:
		for index, item := range v {
			s := item.(string)
			for scanner.Scan() {
				if lineContains(scanner.Text(), s) {
					if index == len(v)-1 {
						return line
					}

					line++
					break
				}
				line++
			}
		}
	case string:
		for scanner.Scan() {
			if lineContains(scanner.Text(), v) {
				return line
			}
			line++
		}
	}

	if err := scanner.Err(); err != nil {
		logger.GetLoggerWithFieldsFromContext(ctx).
			Err(err).
			Str("scanID", scanID).
			Msgf("detecting line. file id %d, search %v", file.ID, i)
	}

	logger.GetLoggerWithFieldsFromContext(ctx).
		Info().
		Str("scanID", scanID).
		Int("fileID", file.ID).
		Msgf("filed to detect line, query response %v", i)

	return UndetectedVulnerabilityLine
}

func lineContains(s, substr string) bool {
	parts := strings.Split(substr, "+")
	if len(parts) == 1 {
		return strings.Contains(s, substr)
	}

	for _, part := range parts {
		if !strings.Contains(s, part) {
			return false
		}
	}

	return true
}

func mapKeyToString(ctx context.Context, m map[string]interface{}, key string) (string, error) {
	v, ok := m[key]
	if !ok {
		return "", fmt.Errorf("key '%s' not found in map", key)
	}

	s, ok := v.(string)
	if !ok {
		logger.GetLoggerWithFieldsFromContext(ctx).
			Debug().
			Msg("detecting line. can't format item to string")
	}

	return s, nil
}

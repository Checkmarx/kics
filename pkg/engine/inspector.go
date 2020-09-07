package engine

import (
	"bufio"
	"context"
	"encoding/json"
	"strconv"
	"strings"

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/open-policy-agent/opa/rego"
	"github.com/pkg/errors"
	"github.com/rs/zerolog/log"
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

func NewInspector(ctx context.Context, source QueriesSource, storage FilesStorage) (*Inspector, error) {
	queries, err := source.GetQueries()
	if err != nil {
		return nil, err
	}

	opaQueries := make([]*preparedQuery, 0, len(queries))
	for _, metadata := range queries {
		opaQuery, err := rego.New(rego.Query("result = data.Cx.result"), rego.Module(metadata.FileName, metadata.Content)).PrepareForEval(ctx)
		if err != nil {
			return nil, errors.Wrap(err, "failed to prepare query metadata")
		}
		opaQueries = append(opaQueries, &preparedQuery{
			opaQuery: opaQuery,
			metadata: metadata,
		})
	}

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
			log.
				Err(err).
				Str("scanID", scanID).
				Msgf("query %s executed with error", query.metadata.FileName)
		}
	}

	return nil
}

func (c *Inspector) doRun(ctx context.Context, scanID string, files model.FileMetadatas, query *preparedQuery) error {
	filesInJSON := files.CombineToJSON()
	filesInMap := files.ToMap()

	// parsing JSON into a structured map required for OPA query
	var inMap map[string]interface{}
	err := json.Unmarshal([]byte(filesInJSON), &inMap)
	if err != nil {
		return errors.Wrap(err, "failed to prepare query results")
	}

	results, err := query.opaQuery.Eval(ctx, rego.EvalInput(inMap))
	if err != nil {
		return errors.Wrap(err, "failed to evaluate query")
	}

	if len(results) == 0 {
		return ErrNoResult
	}

	if err := c.saveResultIfExists(ctx, scanID, results[0].Bindings, filesInMap); err != nil {
		return errors.Wrap(err, "failed to parse query result")
	}

	return nil
}

func (c *Inspector) saveResultIfExists(ctx context.Context, scanID string, vars rego.Vars, filesInMap map[string]model.FileMetadata) error {
	v, ok := vars["result"]
	if !ok {
		return ErrNoResult
	}

	vList := v.([]interface{})
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

		file := filesInMap[interfaceToString(vOjb["id"])]
		line := c.detectLine(&file, vOjb["search"])

		results = append(results, model.Vulnerability{
			FileID:    interfaceToInt(vOjb["id"]),
			ScanID:    scanID,
			QueryName: interfaceToString(vOjb["name"]),
			Severity:  interfaceToString(vOjb["severity"]),
			Line:      line,
			Output:    string(output),
		})
	}

	if err := c.storage.SaveVulnerabilities(ctx, results); err != nil {
		return errors.Wrap(err, "failed to save query results")
	}

	return nil
}

func (c *Inspector) detectLine(file *model.FileMetadata, i interface{}) *int {
	scanner := bufio.NewScanner(strings.NewReader(file.OriginalData))
	line := 1

	switch v := i.(type) {
	case []interface{}:
		for index, item := range v {
			s := item.(string)
			for scanner.Scan() {
				if lineContains(scanner.Text(), s) {
					if index == len(v)-1 {
						return &line
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
				return &line
			}
			line++
		}
	}

	if err := scanner.Err(); err != nil {
		log.
			Err(err).
			Msgf("detecting line: file id %d, search %v", file.ID, i)
	}

	return nil
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

func interfaceToString(v interface{}) string {
	s, ok := v.(string)
	if !ok {
		log.Debug().Msg("inspector: can't format result item to string")
	}

	return s
}

func interfaceToInt(v interface{}) int {
	i, err := strconv.Atoi(interfaceToString(v))
	if err != nil {
		log.Err(err).Msg("inspector: can't format result item to int")
	}

	return i
}

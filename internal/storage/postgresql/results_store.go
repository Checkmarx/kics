package postgresql

import (
	"context"

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/pkg/errors"
)

func (s *PostgresStorage) SaveVulnerabilities(ctx context.Context, items []model.Vulnerability) error {
	const query = `
INSERT INTO ast_ice_results 
	(scan_id, file_id, query_name, query_id, severity, line, issue_type, search_key, key_expected_value, key_actual_value, value, output) 
VALUES 
	(:scan_id, :file_id, :query_name,:query_id, :severity, :line, :issue_type, :search_key, :key_expected_value, :key_actual_value, :value, :output);
`
	for i := range items {
		item := items[i]
		if _, err := s.db.NamedExecContext(ctx, query, map[string]interface{}{
			"scan_id":            item.ScanID,
			"file_id":            item.FileID,
			"query_name":         item.QueryName,
			"query_id":           item.QueryID,
			"severity":           item.Severity,
			"line":               item.Line,
			"issue_type":         item.IssueType,
			"search_key":         item.SearchKey,
			"key_expected_value": item.KeyExpectedValue,
			"key_actual_value":   item.KeyActualValue,
			"value":              item.Value,
			"output":             item.Output,
		}); err != nil {
			return errors.Wrap(err, "inserting result")
		}
	}

	return nil
}

func (s *PostgresStorage) GetResults(ctx context.Context, scanID string) ([]model.ResultItem, error) {
	const query = `
SELECT 
       r.id, r.line, r.query_name, r.query_id, UPPER(r.severity) as severity, f.file_name,
       r.issue_type, r.search_key, r.key_expected_value, r.key_actual_value, r.value
FROM ast_ice_results r 
INNER JOIN ast_ice_files f ON f.id = r.file_id 
WHERE r.scan_id = $1;
`
	results := make([]model.ResultItem, 0)
	if err := s.db.SelectContext(ctx, &results, query, scanID); err != nil {
		return nil, errors.Wrap(err, "selecting results")
	}

	return results, nil
}

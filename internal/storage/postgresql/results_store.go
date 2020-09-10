package postgresql

import (
	"context"

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/pkg/errors"
)

func (s *PostgresStorage) SaveVulnerabilities(ctx context.Context, items []model.Vulnerability) error {
	const query = `
INSERT INTO ast_ice_results 
	(scan_id, file_id, query_name, severity, line, output) 
VALUES 
	(:scan_id, :file_id, :query_name, :severity, :line, :output);
`

	// todo: add all queries to one transaction
	for _, item := range items {
		if _, err := s.db.NamedExecContext(ctx, query, map[string]interface{}{
			"scan_id":    item.ScanID,
			"file_id":    item.FileID,
			"query_name": item.QueryName,
			"severity":   item.Severity,
			"line":       item.Line,
			"output":     item.Output,
		}); err != nil {
			return errors.Wrap(err, "inserting result")
		}
	}

	return nil
}

func (s *PostgresStorage) GetResults(ctx context.Context, scanID string) ([]model.ResultItem, error) {
	const query = `
SELECT 
       r.id, r.line, r.query_name, UPPER(r.severity) as severity, f.file_name 
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

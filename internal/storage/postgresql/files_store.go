package postgresql

import (
	"context"

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/pkg/errors"
)

func (s *PostgresStorage) SaveFile(ctx context.Context, file *model.FileMetadata) error {
	const query = `
INSERT INTO ast_ice_files 
	(scan_id, json_data, orig_data, kind, file_name, json_hash) 
VALUES 
	(:scan_id, :json_data, :orig_data, :kind, :file_name, :json_hash);
`

	if _, err := s.db.NamedExecContext(ctx, query, map[string]interface{}{
		"scan_id":   file.ScanID,
		"json_data": file.JSONData,
		"orig_data": file.OriginalData,
		"kind":      file.Kind,
		"file_name": file.FileName,
		"json_hash": file.JSONHash,
	}); err != nil {
		return errors.Wrap(err, "inserting file")
	}

	return nil
}

func (s *PostgresStorage) GetFiles(ctx context.Context, scanID, jPath string) (model.FileMetadatas, error) {
	var res []model.FileMetadata
	const query = `
SELECT 
	id, scan_id, json_data, orig_data, kind, file_name, json_hash 
FROM 
	ast_ice_files 
WHERE 
	scan_id = $1 AND jsonb_path_exists(json_data, $2);
`
	err := s.db.SelectContext(ctx, &res, query, scanID, jPath)

	return res, errors.Wrap(err, "selecting files")
}

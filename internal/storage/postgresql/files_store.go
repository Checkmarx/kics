package postgresql

import (
	"context"

	"github.com/checkmarxDev/ice/internal/logger"
	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/pkg/errors"
)

type file struct {
	model.FileMetadata
	JSONData string `db:"json_data"`
}

func (s *PostgresStorage) SaveFile(ctx context.Context, file *model.FileMetadata) error {
	jsonData, err := file.Document.MarshalJSON()
	if err != nil {
		return errors.Wrap(err, "failed to marshal document (store)")
	}

	const query = `
INSERT INTO ast_ice_files 
	(scan_id, json_data, orig_data, kind, file_name) 
VALUES 
	(:scan_id, :json_data, :orig_data, :kind, :file_name);
`

	if _, err := s.db.NamedExecContext(ctx, query, map[string]interface{}{
		"scan_id":   file.ScanID,
		"json_data": jsonData,
		"orig_data": file.OriginalData,
		"kind":      file.Kind,
		"file_name": file.FileName,
	}); err != nil {
		return errors.Wrap(err, "inserting file")
	}

	return nil
}

func (s *PostgresStorage) GetFiles(ctx context.Context, scanID string) (model.FileMetadatas, error) {
	var files []file
	const query = `
SELECT 
	id, scan_id, json_data, orig_data, kind, file_name 
FROM 
	ast_ice_files 
WHERE 
	scan_id = $1;
`
	err := s.db.SelectContext(ctx, &files, query, scanID)
	if err != nil {
		return nil, errors.Wrap(err, "failed to get files from store")
	}

	res := make(model.FileMetadatas, 0, len(files))
	for _, f := range files {
		var document model.Document
		if err := document.UnmarshalJSON([]byte(f.JSONData)); err != nil {
			logger.GetLoggerWithFieldsFromContext(ctx).
				Err(err).
				Msg("Json combiner couldn't combine jsons")

			continue
		}

		f.Document = document
		res = append(res, f.FileMetadata)
	}

	return res, nil
}

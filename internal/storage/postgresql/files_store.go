package postgresql

import (
	"context"

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/jmoiron/sqlx"
	"github.com/pkg/errors"
	log "github.com/sirupsen/logrus"
)

type PostgresStorage struct {
	db *sqlx.DB
}

func NewPostgresStore(connectionStr string) (*PostgresStorage, error) {
	db, err := sqlx.Connect("postgres", connectionStr)
	if err != nil {
		return nil, errors.Wrap(err, "failed to connect to postgresql")
	}

	if err := createTables(db); err != nil {
		return nil, errors.Wrap(err, "failed to create tables")
	}

	return &PostgresStorage{db: db}, nil
}

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

func (s *PostgresStorage) Close() {
	if err := s.db.Close(); err != nil {
		log.WithError(err).Error("postgres: db close error")
	}
}

func createTables(db *sqlx.DB) error {
	const query = `
create table if not exists public.ast_ice_files
(
    id          serial not null
        constraint t_data_pkey primary key,
	scan_id varchar(40) not null,
    json_data   jsonb  not null,
    orig_data   text   not null,
    kind        text   not null,
    file_name   text   not null,
    create_date timestamp default now(),
    json_hash   bigint
);

create index if not exists ast_ice_files_scan_id on ast_ice_files (scan_id);

create table if not exists ast_ice_results
(
    id         serial       not null
        constraint t_results_pkey primary key,
    file_id    int          not null,
    scan_id    varchar(40)  not null,
    query_name varchar(255) not null,
    severity   varchar(100) not null,
    line       integer default null,
    output     text         not null,
    constraint t_results_file_fk
        foreign key (file_id)
            references ast_ice_files (id) on delete cascade
);

create index if not exists ast_ice_results_scan_id on ast_ice_results (scan_id);

`
	_, err := db.Exec(query)
	return err
}

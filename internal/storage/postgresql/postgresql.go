package postgresql

import (
	"github.com/jmoiron/sqlx"
	"github.com/pkg/errors"
	"github.com/rs/zerolog/log"
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

func (s *PostgresStorage) Close() {
	if err := s.db.Close(); err != nil {
		log.Err(err).Msg("postgres: db close error")
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
    id                 serial       not null
        constraint t_results_pkey primary key,
    file_id            int          not null,
    scan_id            varchar(40)  not null,
    query_name         varchar(255) not null,
    severity           varchar(100) not null,
    line               integer default 1,
    issue_type         varchar(40)  not null,
    search_key         varchar(255) not null,
    key_expected_value varchar(255),
    key_actual_value   varchar(255),
    output             text         not null,
    constraint t_results_file_fk
        foreign key (file_id)
            references ast_ice_files (id) on delete cascade
);

create index if not exists ast_ice_results_scan_id on ast_ice_results (scan_id);

`
	_, err := db.Exec(query)
	return err
}

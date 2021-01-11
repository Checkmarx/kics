#!/usr/bin/env bash
QUERIES_DIR=${QUERIES_DIR:-"../assets"}
BACKUP_DIR=${BACKUP_DIR:-"${QUERIES_DIR}-bkp"}

rm -f execution.log

echo 'Backing up queries'
cp -vR "${QUERIES_DIR}" "${BACKUP_DIR}"

echo 'Running pre-compute similarity ID tool'
go run generate_unit_tests_similarity_id.go | tee execution.log

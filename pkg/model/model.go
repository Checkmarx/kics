package model

import (
	"context"
	"strconv"

	"github.com/checkmarxDev/ice/internal/logger"
	"github.com/pkg/errors"
)

const (
	KindTerraform FileMetadataKind = "TF"

	SeverityHigh   = "HIGH"
	SeverityMedium = "MEDIUM"
	SeverityLow    = "LOW"
	SeverityInfo   = "INFO"

	IssueTypeMissingAttribute   IssueType = "MissingAttribute"
	IssueTypeRedundantAttribute IssueType = "RedundantAttribute"
	IssueTypeIncorrectValue     IssueType = "IncorrectValue"
)

var (
	AllSeverities = []Severity{
		SeverityHigh,
		SeverityMedium,
		SeverityLow,
		SeverityInfo,
	}
)

type FileMetadataKind string
type Severity string
type IssueType string

type FileMetadata struct {
	ID           int
	ScanID       string `db:"scan_id"`
	JSONData     string `db:"json_data"`
	OriginalData string `db:"orig_data"`
	Kind         FileMetadataKind
	FileName     string `db:"file_name"`
	JSONHash     uint32 `db:"json_hash"`
}

type QueryMetadata struct {
	ID       int
	FileName string
	Content  string
	Filter   string
	Metadata map[string]interface{}
}

type Vulnerability struct {
	ID               int       `json:"id"`
	ScanID           string    `db:"scan_id" json:"-"`
	FileID           int       `db:"file_id" json:"-"`
	FileName         string    `db:"file_name" json:"fileName"`
	QueryID          string    `db:"query_id" json:"queryID"`
	QueryName        string    `db:"query_name" json:"queryName"`
	Severity         Severity  `json:"severity"`
	Line             int       `json:"line"`
	IssueType        IssueType `db:"issue_type" json:"issueType"`
	SearchKey        string    `db:"search_key" json:"searchKey"`
	KeyExpectedValue string    `db:"key_expected_value" json:"expectedValue"`
	KeyActualValue   string    `db:"key_actual_value" json:"actualValue"`
	Value            *string   `db:"value" json:"value"`
	Output           string    `json:"-"`
}

type FileMetadatas []FileMetadata

func (m FileMetadatas) ToMap() map[string]FileMetadata {
	c := make(map[string]FileMetadata, len(m))
	for _, i := range m {
		c[strconv.Itoa(i.ID)] = i
	}

	return c
}

//easyjson:json
type Documents struct {
	Documents []Document `json:"document"`
}

//easyjson:json
type Document map[string]interface{}

func (m FileMetadatas) CombineToJSON(ctx context.Context) (string, error) {
	documents := Documents{Documents: make([]Document, 0, len(m))}
	for _, fm := range m {
		var document Document
		if err := document.UnmarshalJSON([]byte(fm.JSONData)); err != nil {
			logger.GetLoggerWithFieldsFromContext(ctx).
				Err(err).
				Msg("Json combiner couldn't combine jsons")

			continue
		}
		if len(document) == 0 {
			continue
		}

		document["id"] = strconv.Itoa(fm.ID)
		document["file"] = fm.FileName

		documents.Documents = append(documents.Documents, document)
	}

	ret, err := documents.MarshalJSON()
	if err != nil {
		return "", errors.Wrap(err, "failed to marshall all files")
	}

	return string(ret), nil
}

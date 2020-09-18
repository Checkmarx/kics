package model

import (
	"strconv"

	"github.com/pkg/errors"
	"github.com/rs/zerolog/log"
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
	FileID           int       `db:"file_id" json:"file_id"`
	QueryName        string    `db:"query_name" json:"query_name"`
	Severity         Severity  `json:"severity"`
	Line             int       `json:"line"`
	IssueType        IssueType `db:"issue_type"`
	KeyExpectedValue *string   `db:"key_expected_value"`
	KeyActualValue   *string   `db:"key_actual_value"`
	Output           string    `json:"-"`
}

type ResultItem struct {
	ID               int       `json:"id"`
	FileName         string    `db:"file_name" json:"fileName"`
	Line             int       `json:"line"`
	QueryName        string    `db:"query_name" json:"queryName"`
	Severity         Severity  `json:"severity"`
	IssueType        IssueType `db:"issue_type" json:"issue_type"`
	KeyExpectedValue *string   `db:"key_expected_value" json:"key_expected_value"`
	KeyActualValue   *string   `db:"key_actual_value" json:"key_actual_value"`
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

func (m FileMetadatas) CombineToJSON() (string, error) {
	documents := Documents{Documents: make([]Document, 0, len(m))}
	for _, fm := range m {
		var document Document
		if err := document.UnmarshalJSON([]byte(fm.JSONData)); err != nil {
			log.Err(err).
				Msg("invalid file metadata json")

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

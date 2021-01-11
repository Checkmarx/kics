package model

import (
	"sort"
	"strings"
)

const (
	KindTerraform FileKind = "TF"
	KindJSON      FileKind = "JSON"
	KindYAML      FileKind = "YAML"
	KindDOCKER    FileKind = "DOCKERFILE"

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

	AllIssueTypesAsString = []string{
		string(IssueTypeMissingAttribute),
		string(IssueTypeRedundantAttribute),
		string(IssueTypeIncorrectValue),
	}
)

type FileKind string
type Severity string
type IssueType string

type FileMetadata struct {
	ID           string `db:"id"`
	ScanID       string `db:"scan_id"`
	Document     Document
	OriginalData string   `db:"orig_data"`
	Kind         FileKind `db:"kind"`
	FileName     string   `db:"file_name"`
}

type QueryMetadata struct {
	Query    string
	Content  string
	Metadata map[string]interface{}
	Platform string
}

type Vulnerability struct {
	ID               int       `json:"id"`
	ScanID           string    `db:"scan_id" json:"-"`
	FileID           string    `db:"file_id" json:"-"`
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

type QueryConfig struct {
	FileKind FileKind
	Platform string
}

type Extensions map[string]struct{}

func (e Extensions) Include(ext string) bool {
	_, b := e[ext]

	return b
}

func (e Extensions) MatchedFilesRegex() string {
	if len(e) == 0 {
		return "NO_MATCHED_FILES"
	}

	var parts []string
	for ext := range e {
		parts = append(parts, "\\"+ext)
	}

	sort.Strings(parts)

	return "(.*)(" + strings.Join(parts, "|") + ")$"
}

type FileMetadatas []FileMetadata

func (m FileMetadatas) ToMap() map[string]FileMetadata {
	c := make(map[string]FileMetadata, len(m))
	for _, i := range m {
		c[i.ID] = i
	}

	return c
}

//easyjson:json
type Documents struct {
	Documents []Document `json:"document"`
}

//easyjson:json
type Document map[string]interface{}

func (m FileMetadatas) Combine() Documents {
	documents := Documents{Documents: make([]Document, 0, len(m))}
	for _, fm := range m {
		if len(fm.Document) == 0 {
			continue
		}

		fm.Document["id"] = fm.ID
		fm.Document["file"] = fm.FileName

		documents.Documents = append(documents.Documents, fm.Document)
	}

	return documents
}

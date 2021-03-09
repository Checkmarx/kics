package model

import (
	"sort"
	"strings"
)

// Constants to describe what kind of file refers
const (
	KindTerraform FileKind = "TF"
	KindJSON      FileKind = "JSON"
	KindYAML      FileKind = "YAML"
	KindDOCKER    FileKind = "DOCKERFILE"
	KindCOMMON    FileKind = "*"
)

// Constants to describe vulnerability's severity
const (
	SeverityHigh   = "HIGH"
	SeverityMedium = "MEDIUM"
	SeverityLow    = "LOW"
	SeverityInfo   = "INFO"
)

// Constants to describe issue's type
const (
	IssueTypeMissingAttribute   IssueType = "MissingAttribute"
	IssueTypeRedundantAttribute IssueType = "RedundantAttribute"
	IssueTypeIncorrectValue     IssueType = "IncorrectValue"
)

// Arrays to group all constants of one type
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

// FileKind is the extension of a file
type FileKind string

// Severity of the vulnerability
type Severity string

// IssueType is the issue's type string representation
type IssueType string

// VulnLines is the lines containing and adjecent to the vulnerability line with their respective positions
type VulnLines struct {
	Positions []int
	Lines     []string
}

// FileMetadata is a representation of basic information and content of a file
type FileMetadata struct {
	ID           string `db:"id"`
	ScanID       string `db:"scan_id"`
	Document     Document
	OriginalData string   `db:"orig_data"`
	Kind         FileKind `db:"kind"`
	FileName     string   `db:"file_name"`
}

// QueryMetadata is a representation of general information about a query
type QueryMetadata struct {
	Query    string
	Content  string
	Metadata map[string]interface{}
	Platform string
	// special field for generic queries
	// represents how many queries are aggregated into a single rego file
	Aggregation int
}

// Vulnerability is a representation of a detected vulnerability in scanned files
// after running a query
type Vulnerability struct {
	ID               int       `json:"id"`
	ScanID           string    `db:"scan_id" json:"-"`
	SimilarityID     string    `db:"similarity_id" json:"similarityID"`
	FileID           string    `db:"file_id" json:"-"`
	FileName         string    `db:"file_name" json:"fileName"`
	QueryID          string    `db:"query_id" json:"queryID"`
	QueryName        string    `db:"query_name" json:"queryName"`
	Category         string    `json:"category"`
	Description      string    `json:"description"`
	Platform         string    `db:"platform" json:"platform"`
	Severity         Severity  `json:"severity"`
	Line             int       `json:"line"`
	VulnLines        VulnLines `json:"vulnLines"`
	IssueType        IssueType `db:"issue_type" json:"issueType"`
	SearchKey        string    `db:"search_key" json:"searchKey"`
	SearchValue      string    `db:"search_value" json:"searchValue"`
	KeyExpectedValue string    `db:"key_expected_value" json:"expectedValue"`
	KeyActualValue   string    `db:"key_actual_value" json:"actualValue"`
	Value            *string   `db:"value" json:"value"`
	Output           string    `json:"-"`
}

// QueryConfig is a struct that contains the fileKind and platform of the rego query
type QueryConfig struct {
	FileKind []FileKind
	Platform string
}

// Extensions represents a list of supported extensions
type Extensions map[string]struct{}

// Include returns true if an extension is included in supported extensions listed
// otherwise returns false
func (e Extensions) Include(ext string) bool {
	_, b := e[ext]

	return b
}

// MatchedFilesRegex returns the regex rule to identify if an extension is supported or not
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

// FileMetadatas is a slice of FileMetadata
type FileMetadatas []FileMetadata

// ToMap creates a map of FileMetadatas, which the key is the FileMedata ID and the value is the FileMetadata
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

// Combine merge documents from FileMetadatas using the ID as reference for Document ID and FileName as reference for file
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

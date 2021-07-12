// Package model (go:generate go run -mod=mod github.com/mailru/easyjson/easyjson ./$GOFILE)
package model

import (
	"sort"
	"strings"

	_ "github.com/mailru/easyjson/gen" //nolint
)

// Constants to describe what kind of file refers
const (
	KindTerraform FileKind = "TF"
	KindJSON      FileKind = "JSON"
	KindYAML      FileKind = "YAML"
	KindDOCKER    FileKind = "DOCKERFILE"
	KindCOMMON    FileKind = "*"
	KindHELM      FileKind = "HELM"
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

// VulnerabilityLines is the representation of the found line for issue
type VulnerabilityLines struct {
	Line                 int
	VulnLines            []CodeLine
	LineWithVulnerabilty string
}

// FileKind is the extension of a file
type FileKind string

// Severity of the vulnerability
type Severity string

// IssueType is the issue's type string representation
type IssueType string

// CodeLine is the lines containing and adjecent to the vulnerability line with their respective positions
type CodeLine struct {
	Position int
	Line     string
}

// ExtractedPathObject is the struct that contains the path location of extracted source
// and a boolean to check if it is a local source
type ExtractedPathObject struct {
	Path      string
	LocalPath bool
}

// FileMetadata is a representation of basic information and content of a file
type FileMetadata struct {
	ID           string `db:"id"`
	ScanID       string `db:"scan_id"`
	Document     Document
	OriginalData string   `db:"orig_data"`
	Kind         FileKind `db:"kind"`
	FileName     string   `db:"file_name"`
	Content      string
	HelmID       string
	IDInfo       map[int]interface{}
}

// QueryMetadata is a representation of general information about a query
type QueryMetadata struct {
	InputData string
	Query     string
	Content   string
	Metadata  map[string]interface{}
	Platform  string
	// special field for generic queries
	// represents how many queries are aggregated into a single rego file
	Aggregation int
}

// Vulnerability is a representation of a detected vulnerability in scanned files
// after running a query
type Vulnerability struct {
	ID               int        `json:"id"`
	ScanID           string     `db:"scan_id" json:"-"`
	SimilarityID     string     `db:"similarity_id" json:"similarityID"`
	FileID           string     `db:"file_id" json:"-"`
	FileName         string     `db:"file_name" json:"fileName"`
	QueryID          string     `db:"query_id" json:"queryID"`
	QueryName        string     `db:"query_name" json:"queryName"`
	QueryURI         string     `json:"-"`
	Category         string     `json:"category"`
	Description      string     `json:"description"`
	DescriptionID    string     `json:"descriptionID"`
	Platform         string     `db:"platform" json:"platform"`
	Severity         Severity   `json:"severity"`
	Line             int        `json:"line"`
	VulnLines        []CodeLine `json:"vulnLines"`
	IssueType        IssueType  `db:"issue_type" json:"issueType"`
	SearchKey        string     `db:"search_key" json:"searchKey"`
	SearchValue      string     `db:"search_value" json:"searchValue"`
	KeyExpectedValue string     `db:"key_expected_value" json:"expectedValue"`
	KeyActualValue   string     `db:"key_actual_value" json:"actualValue"`
	Value            *string    `db:"value" json:"value"`
	Output           string     `json:"-"`
}

// QueryConfig is a struct that contains the fileKind and platform of the rego query
type QueryConfig struct {
	FileKind []FileKind
	Platform string
}

// ResolvedFiles keeps the information of all file/template resolved
type ResolvedFiles struct {
	File []ResolvedFile
}

// ResolvedFile keeps the information of a file/template resolved
type ResolvedFile struct {
	FileName     string
	Content      []byte
	OriginalData []byte
	SplitID      string
	IDInfo       map[int]interface{}
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
	for i := 0; i < len(m); i++ {
		c[m[i].ID] = m[i]
	}
	return c
}

// Documents (easyjson:json)
type Documents struct {
	Documents []Document `json:"document"`
}

// Document (easyjson:json)
type Document map[string]interface{}

// Combine merge documents from FileMetadatas using the ID as reference for Document ID and FileName as reference for file
func (m FileMetadatas) Combine() Documents {
	documents := Documents{Documents: make([]Document, 0, len(m))}
	for i := 0; i < len(m); i++ {
		if len(m[i].Document) == 0 {
			continue
		}
		m[i].Document["id"] = m[i].ID
		m[i].Document["file"] = m[i].FileName
		documents.Documents = append(documents.Documents, m[i].Document)
	}
	return documents
}

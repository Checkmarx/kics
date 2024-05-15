package model

import (
	"regexp"
	"sort"
	"strings"

	"github.com/rs/zerolog/log"
)

// Constants to describe what kind of file refers
const (
	KindTerraform FileKind = "TF"
	KindBICEP     FileKind = "BICEP"
	KindJSON      FileKind = "JSON"
	KindYAML      FileKind = "YAML"
	KindYML       FileKind = "YML"
	KindDOCKER    FileKind = "DOCKERFILE"
	KindPROTO     FileKind = "PROTO"
	KindCOMMON    FileKind = "*"
	KindHELM      FileKind = "HELM"
	KindBUILDAH   FileKind = "SH"
	KindCFG       FileKind = "CFG"
	KindINI       FileKind = "INI"
)

// Constants to describe commands given from comments
const (
	IgnoreLine    CommentCommand = "ignore-line"
	IgnoreBlock   CommentCommand = "ignore-block"
	IgnoreComment CommentCommand = "ignore-comment"
)

// Constants to describe vulnerability's severity
const (
	SeverityCritical = "CRITICAL"
	SeverityHigh     = "HIGH"
	SeverityMedium   = "MEDIUM"
	SeverityLow      = "LOW"
	SeverityInfo     = "INFO"
	SeverityTrace    = "TRACE"
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
		SeverityCritical,
		SeverityHigh,
		SeverityMedium,
		SeverityLow,
		SeverityInfo,
		SeverityTrace,
	}

	AllIssueTypesAsString = []string{
		string(IssueTypeMissingAttribute),
		string(IssueTypeRedundantAttribute),
		string(IssueTypeIncorrectValue),
	}
)

var (
	// KICSCommentRgxp is the regexp to identify if a comment is a KICS comment
	KICSCommentRgxp = regexp.MustCompile(`(^|\n)((/{2})|#|;)*\s*kics-scan\s*`)
	// KICSGetContentCommentRgxp to gets the kics comment on the hel case
	KICSGetContentCommentRgxp = regexp.MustCompile(`(^|\n)((/{2})|#|;)*\s*kics-scan([^\n]*)\n`)
	// KICSCommentRgxpYaml is the regexp to identify if the comment has KICS comment at the end of the comment in YAML
	KICSCommentRgxpYaml = regexp.MustCompile(`((/{2})|#)*\s*kics-scan\s*(ignore-line|ignore-block)\s*\n*$`)
)

// Version - is the model for the version response
type Version struct {
	Latest           bool   `json:"is_latest"`
	LatestVersionTag string `json:"latest_version"`
}

// VulnerabilityLines is the representation of the found line for issue
type VulnerabilityLines struct {
	Line                  int
	VulnLines             *[]CodeLine
	LineWithVulnerability string
	ResolvedFile          string
}

// CommentCommand represents a command given from a comment
type CommentCommand string

// FileKind is the extension of a file
type FileKind string

// Severity of the vulnerability
type Severity string

// IssueType is the issue's type string representation
type IssueType string

// CodeLine is the lines containing and adjacent to the vulnerability line with their respective positions
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

// CommentsCommands list of commands on a file that will be parsed
type CommentsCommands map[string]string

// FileMetadata is a representation of basic information and content of a file
type FileMetadata struct {
	ID                string `db:"id"`
	ScanID            string `db:"scan_id"`
	Document          Document
	LineInfoDocument  map[string]interface{}
	OriginalData      string   `db:"orig_data"`
	Kind              FileKind `db:"kind"`
	FilePath          string   `db:"file_path"`
	Content           string
	HelmID            string
	IDInfo            map[int]interface{}
	Commands          CommentsCommands
	LinesIgnore       []int
	ResolvedFiles     map[string]ResolvedFile
	LinesOriginalData *[]string
	IsMinified        bool
}

// QueryMetadata is a representation of general information about a query
type QueryMetadata struct {
	InputData string
	Query     string
	Content   string
	Metadata  map[string]interface{}
	Platform  string
	CWE       string
	// special field for generic queries
	// represents how many queries are aggregated into a single rego file
	Aggregation  int
	Experimental bool
}

// Vulnerability is a representation of a detected vulnerability in scanned files
// after running a query
type Vulnerability struct {
	ID               int         `json:"id"`
	ScanID           string      `db:"scan_id" json:"-"`
	SimilarityID     string      `db:"similarity_id" json:"similarityID"`
	OldSimilarityID  string      `db:"old_similarity_id" json:"oldSimilarityID"`
	FileID           string      `db:"file_id" json:"-"`
	FileName         string      `db:"file_name" json:"fileName"`
	QueryID          string      `db:"query_id" json:"queryID"`
	QueryName        string      `db:"query_name" json:"queryName"`
	QueryURI         string      `json:"-"`
	Category         string      `json:"category"`
	Experimental     bool        `json:"experimental"`
	Description      string      `json:"description"`
	DescriptionID    string      `json:"descriptionID"`
	Platform         string      `db:"platform" json:"platform"`
	CWE              string      `db:"cwe" json:"cwe"`
	Severity         Severity    `json:"severity"`
	Line             int         `json:"line"`
	VulnLines        *[]CodeLine `json:"vulnLines"`
	ResourceType     string      `db:"resource_type" json:"resourceType"`
	ResourceName     string      `db:"resource_name" json:"resourceName"`
	IssueType        IssueType   `db:"issue_type" json:"issueType"`
	SearchKey        string      `db:"search_key" json:"searchKey"`
	SearchLine       int         `db:"search_line" json:"searchLine"`
	SearchValue      string      `db:"search_value" json:"searchValue"`
	KeyExpectedValue string      `db:"key_expected_value" json:"expectedValue"`
	KeyActualValue   string      `db:"key_actual_value" json:"actualValue"`
	Value            *string     `db:"value" json:"value"`
	Output           string      `json:"-"`
	CloudProvider    string      `json:"cloud_provider"`
	Remediation      string      `db:"remediation" json:"remediation"`
	RemediationType  string      `db:"remediation_type" json:"remediation_type"`
}

// QueryConfig is a struct that contains the fileKind and platform of the rego query
type QueryConfig struct {
	FileKind []FileKind
	Platform string
}

// ResolvedFiles keeps the information of all file/template resolved
type ResolvedFiles struct {
	File     []ResolvedHelm
	Excluded []string
}

// ResolvedHelm keeps the information of a file/template resolved
type ResolvedHelm struct {
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

// LineObject is the struct that will hold line information for each key
type LineObject struct {
	Line int                      `json:"_kics_line"`
	Arr  []map[string]*LineObject `json:"_kics_arr,omitempty"`
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

// Documents
type Documents struct {
	Documents []Document `json:"document"`
}

// Document
type Document map[string]interface{}

// Combine merge documents from FileMetadatas using the ID as reference for Document ID and FileName as reference for file
func (m FileMetadatas) Combine(lineInfo bool) Documents {
	documents := Documents{Documents: make([]Document, 0, len(m))}
	for i := 0; i < len(m); i++ {
		_, ignore := m[i].Commands["ignore"]
		if len(m[i].Document) == 0 {
			continue
		}
		if ignore {
			log.Debug().Msgf("Ignoring file %s", m[i].FilePath)
			continue
		}
		if lineInfo {
			m[i].LineInfoDocument["id"] = m[i].ID
			m[i].LineInfoDocument["file"] = m[i].FilePath
			documents.Documents = append(documents.Documents, m[i].LineInfoDocument)
		} else {
			m[i].Document["id"] = m[i].ID
			m[i].Document["file"] = m[i].FilePath
			documents.Documents = append(documents.Documents, m[i].Document)
		}
	}
	return documents
}

// AnalyzedPaths is a slice of types and excluded files obtained from the Analyzer
type AnalyzedPaths struct {
	Types       []string
	Exc         []string
	ExpectedLOC int
}

// ResolvedFileSplit is a struct that contains the information of a resolved file, the path and the lines of the file
type ResolvedFileSplit struct {
	Path  string
	Lines []string
}

// ResolvedFile is a struct that contains the information of a resolved file, the path and the content in bytes of the file
type ResolvedFile struct {
	Path         string
	Content      []byte
	LinesContent *[]string
}

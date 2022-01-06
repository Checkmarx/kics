package model

import (
	"fmt"
	"os"
	"path/filepath"
	"regexp"
	"sort"
	"strings"
	"time"

	"github.com/gookit/color"
	"github.com/rs/zerolog/log"
)

// SeveritySummary contains scans' result numbers, how many vulnerabilities of each severity was detected
type SeveritySummary struct {
	ScanID            string           `json:"scan_id"`
	SeverityCounters  map[Severity]int `json:"severity_counters"`
	TotalCounter      int              `json:"total_counter"`
	TotalBOMResources int              `json:"total_bom_resources"`
}

// VulnerableFile contains information of a vulnerable file and where the vulnerability was found
type VulnerableFile struct {
	FileName         string     `json:"file_name"`
	SimilarityID     string     `json:"similarity_id"`
	Line             int        `json:"line"`
	VulnLines        []CodeLine `json:"-"`
	IssueType        IssueType  `json:"issue_type"`
	SearchKey        string     `json:"search_key"`
	SearchLine       int        `json:"search_line"`
	SearchValue      string     `json:"search_value"`
	KeyExpectedValue string     `json:"expected_value"`
	KeyActualValue   string     `json:"actual_value"`
	Value            *string    `json:"value,omitempty"`
}

// QueryResult contains a query that tested positive ID, name, severity and a list of files that tested vulnerable
type QueryResult struct {
	QueryName                   string           `json:"query_name"`
	QueryID                     string           `json:"query_id"`
	QueryURI                    string           `json:"query_url"`
	Severity                    Severity         `json:"severity"`
	Platform                    string           `json:"platform"`
	Category                    string           `json:"category"`
	Description                 string           `json:"description"`
	DescriptionID               string           `json:"description_id"`
	CISDescriptionIDFormatted   string           `json:"cis_description_id,omitempty"`
	CISDescriptionTitle         string           `json:"cis_description_title,omitempty"`
	CISDescriptionTextFormatted string           `json:"cis_description_text,omitempty"`
	CISDescriptionID            string           `json:"cis_description_id_raw,omitempty"`
	CISDescriptionText          string           `json:"cis_description_text_raw,omitempty"`
	CISRationaleText            string           `json:"cis_description_rationale,omitempty"`
	CISBenchmarkName            string           `json:"cis_benchmark_name,omitempty"`
	CISBenchmarkVersion         string           `json:"cis_benchmark_version,omitempty"`
	Files                       []VulnerableFile `json:"files"`
}

// QueryResultSlice is a slice of QueryResult
type QueryResultSlice []QueryResult

// Counters hold information about how many files were scanned, parsed, failed to be scaned, the total of queries
// and how many queries failed to execute
type Counters struct {
	ScannedFiles           int `json:"files_scanned"`
	ParsedFiles            int `json:"files_parsed"`
	FailedToScanFiles      int `json:"files_failed_to_scan"`
	TotalQueries           int `json:"queries_total"`
	FailedToExecuteQueries int `json:"queries_failed_to_execute"`
	FailedSimilarityID     int `json:"queries_failed_to_compute_similarity_id"`
}

// Times represents an object that contains the start and end time of the scan
type Times struct {
	Start time.Time `json:"start"`
	End   time.Time `json:"end"`
}

// VersionResponse - is the model for the version response
type VersionResponse struct {
	Latest           bool   `json:"is_latest"`
	LatestVersionTag string `json:"latest_version"`
}

// Summary is a report of a single scan
type Summary struct {
	Version       string  `json:"kics_version,omitempty"`
	LatestVersion Version `json:"-"`
	Counters
	SeveritySummary
	Times
	ScannedPaths []string         `json:"paths"`
	Queries      QueryResultSlice `json:"queries"`
	Bom          QueryResultSlice `json:"bill_of_materials,omitempty"`
}

// PathParameters - structure wraps the required fields for temporary path translation
type PathParameters struct {
	ScannedPaths      []string
	PathExtractionMap map[string]ExtractedPathObject
}

var (
	queryRegex   = regexp.MustCompile(`\?([\w-]+(=[\w-]*)?(&[\w-]+(=[\w-]*)?)*)?`)
	urlAuthRegex = regexp.MustCompile(`((ssh|https?)://)(\S+(:\S*)?@).*`)
)

const authGroupPosition = 3

func getRelativePath(basePath, filePath string) string {
	var returnPath string
	relativePath, err := filepath.Rel(basePath, filePath)
	if err != nil {
		returnPath = filePath
	} else {
		returnPath = relativePath
	}
	return returnPath
}

func replaceIfTemporaryPath(filePath string, pathExtractionMap map[string]ExtractedPathObject) string {
	prettyPath := filePath
	for key, val := range pathExtractionMap {
		if strings.Contains(filePath, key) {
			splittedPath := strings.Split(filePath, key)
			if !val.LocalPath {
				// remove authentication information from the URL
				sanitizedURL := removeURLCredentials(val.Path)
				// remove query parameters '?key=value&key2=value'
				return filepath.FromSlash(queryRegex.ReplaceAllString(sanitizedURL, "") + splittedPath[1])
			}
			prettyPath = filepath.FromSlash(filepath.Base(val.Path) + splittedPath[1])
		} else {
			prettyPath = filePath
		}
	}
	return prettyPath
}

func removeAllURLCredentials(pathExtractionMap map[string]ExtractedPathObject) []string {
	sanitizedScannedPaths := make([]string, 0)
	for _, val := range pathExtractionMap {
		if !val.LocalPath {
			sanitizedURL := removeURLCredentials(val.Path)
			sanitizedScannedPaths = append(sanitizedScannedPaths, sanitizedURL)
		} else {
			sanitizedScannedPaths = append(sanitizedScannedPaths, val.Path)
		}
	}
	return sanitizedScannedPaths
}

func removeURLCredentials(url string) string {
	authGroup := ""
	groups := urlAuthRegex.FindStringSubmatch(url)
	// credentials are present in the URL
	if len(groups) > authGroupPosition {
		authGroup = groups[authGroupPosition]
	}
	return strings.Replace(url, authGroup, "", 1)
}

func resolvePath(filePath string, pathExtractionMap map[string]ExtractedPathObject) string {
	var returnPath string
	returnPath = replaceIfTemporaryPath(filepath.FromSlash(filePath), pathExtractionMap)
	pwd, err := os.Getwd()
	if err != nil {
		log.Error().Msgf("Unable to get current working dir %s", err)
		return returnPath
	}
	returnPath = getRelativePath(pwd, returnPath)
	return returnPath
}

// CreateSummary creates a report for a single scan, based on its scanID
func CreateSummary(counters Counters, vulnerabilities []Vulnerability,
	scanID string, pathExtractionMap map[string]ExtractedPathObject, version Version) Summary {
	log.Debug().Msg("model.CreateSummary()")
	q := make(map[string]QueryResult, len(vulnerabilities))
	severitySummary := SeveritySummary{
		ScanID: scanID,
	}
	for i := range vulnerabilities {
		item := vulnerabilities[i]
		if _, ok := q[item.QueryID]; !ok {
			q[item.QueryID] = QueryResult{
				QueryName:     item.QueryName,
				QueryID:       item.QueryID,
				Severity:      item.Severity,
				QueryURI:      item.QueryURI,
				Platform:      item.Platform,
				Category:      item.Category,
				Description:   item.Description,
				DescriptionID: item.DescriptionID,
			}
		}

		qItem := q[item.QueryID]
		qItem.Files = append(qItem.Files, VulnerableFile{
			FileName:         resolvePath(item.FileName, pathExtractionMap),
			SimilarityID:     item.SimilarityID,
			Line:             item.Line,
			VulnLines:        item.VulnLines,
			IssueType:        item.IssueType,
			SearchKey:        item.SearchKey,
			SearchValue:      item.SearchValue,
			KeyExpectedValue: item.KeyExpectedValue,
			KeyActualValue:   item.KeyActualValue,
			Value:            item.Value,
		})

		q[item.QueryID] = qItem
	}

	queries := make([]QueryResult, 0, len(q))
	sevs := map[Severity]int{SeverityTrace: 0, SeverityInfo: 0, SeverityLow: 0, SeverityMedium: 0, SeverityHigh: 0}
	for idx := range q {
		sevs[q[idx].Severity] += len(q[idx].Files)

		if q[idx].Severity == SeverityTrace {
			continue
		}
		queries = append(queries, q[idx])

		severitySummary.TotalCounter += len(q[idx].Files)
	}

	severityOrder := map[Severity]int{SeverityTrace: 4, SeverityInfo: 3, SeverityLow: 2, SeverityMedium: 1, SeverityHigh: 0}
	sort.Slice(queries, func(i, j int) bool {
		if severityOrder[queries[i].Severity] == severityOrder[queries[j].Severity] {
			return queries[i].QueryName < queries[j].QueryName
		}
		return severityOrder[queries[i].Severity] < severityOrder[queries[j].Severity]
	})

	materials := make([]QueryResult, 0, len(q))
	for idx := range q {
		if q[idx].Severity == SeverityTrace {
			materials = append(materials, q[idx])
			severitySummary.TotalBOMResources += len(q[idx].Files)
		}
	}

	severitySummary.SeverityCounters = sevs

	return Summary{
		Bom:             materials,
		Counters:        counters,
		Queries:         queries,
		SeveritySummary: severitySummary,
		ScannedPaths:    removeAllURLCredentials(pathExtractionMap),
		LatestVersion:   version,
	}
}

// PrintVersionCheck - Prints and logs warning if not using KICS latest version
func (s *Summary) PrintVersionCheck() {
	if !s.LatestVersion.Latest {
		message := fmt.Sprintf("A new version 'v%s' of KICS is available, please consider updating", s.LatestVersion.LatestVersionTag)
		orange := 214
		color.C256(uint8(orange)).Println(message)
		log.Warn().Msgf(message)
	}
}

package model

import (
	"crypto/sha256"
	"encoding/hex"
	"encoding/xml"
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"time"

	"github.com/Checkmarx/kics/v2/internal/constants"
	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/google/uuid"
	"github.com/rs/zerolog/log"
)

var cycloneDxSeverityLevelEquivalence = map[model.Severity]string{
	"INFO":     "None",
	"LOW":      "Low",
	"MEDIUM":   "Medium",
	"HIGH":     "High",
	"CRITICAL": "Critical",
}

// CycloneDxReport includes all the properties considered relevant for the CycloneDX Report
type CycloneDxReport struct {
	XMLName xml.Name `xml:"bom"`

	// bom tag information
	XMLNS        string `xml:"xmlns,attr"`
	SerialNumber string `xml:"serialNumber,attr"`
	XMLNSV       string `xml:"xmlns:v,attr"`
	Version      int    `xml:"version,attr"`

	// bom body information
	Metadata   *Metadata  `xml:"metadata"`
	Components Components `xml:"components"`
}

// Metadata includes the relevant additional information about the CycloneDX report
type Metadata struct {
	Timestamp string  `xml:"timestamp"`  // the timestamp when the CycloneDX report is created
	Tools     *[]Tool `xml:"tools>tool"` // array of tools used to create the CycloneDX report
}

// Tool includes the information about the tool used to create the CycloneDX report
type Tool struct {
	Vendor  string `xml:"vendor"`
	Name    string `xml:"name"`
	Version string `xml:"version"`
}

// Components is a list of components
type Components struct {
	Components []Component `xml:"component"`
}

// Component includes the CycloneDX component structure properties considered relevant
type Component struct {
	// component tag information
	Type   string `xml:"type,attr"`
	BomRef string `xml:"bom-ref,attr"`

	// component body information
	Name            string          `xml:"name"`
	Version         string          `xml:"version"`
	Hashes          []Hash          `xml:"hashes>hash"`
	Purl            string          `xml:"purl"`
	Vulnerabilities []Vulnerability `xml:"v:vulnerabilities>v:vulnerability"`
}

// Hash includes the algorithm used in the HASH function and the output of it (content)
type Hash struct {
	Alg     string `xml:"alg,attr"`
	Content string `xml:",chardata"`
}

// Vulnerability includes all the relevant information about the vulnerability
type Vulnerability struct {
	// vulnerability tag information
	Ref string `xml:"ref,attr"`

	// vulnerability body information
	ID              string           `xml:"v:id"`
	CWE             string           `xml:"v:cwe"`
	Source          Source           `xml:"v:source"`
	Ratings         []Rating         `xml:"v:ratings>v:rating"`
	Description     string           `xml:"v:description"`
	Recommendations []Recommendation `xml:"v:recommendations>v:recommendation"`
}

// Source includes information about the origin where the vulnerability was reported
type Source struct {
	Name string `xml:"name"`
	URL  string `xml:"url"`
}

// Rating includes the severity of the vulnerability and the method used to classify it
type Rating struct {
	Severity string `xml:"v:severity"`
	Method   string `xml:"v:method"`
}

// Recommendation describes how the vulnerability should be avoided
type Recommendation struct {
	Recommendation string `xml:""`
}

func match(fileNames []model.VulnerableFile, fileName string) bool {
	for i := range fileNames {
		if fileNames[i].FileName == fileName {
			return true
		}
	}
	return false
}

func getAllFiles(summary *model.Summary) []model.VulnerableFile {
	var fileNames []model.VulnerableFile
	for i := range summary.Queries {
		files := summary.Queries[i].Files
		for idx := range files {
			if !match(fileNames, files[idx].FileName) {
				fileNames = append(fileNames, files[idx])
			}
		}
	}
	return fileNames
}

func generateSha256(filePath string, filePaths map[string]string) string {
	file := filePaths[filePath]
	content, err := os.ReadFile(filepath.Clean(file))

	if err != nil {
		log.Trace().Msgf("failed to read %s", file)
		return ""
	}

	hashSum := sha256.Sum256(content)
	return hex.EncodeToString(hashSum[:])
}

func getPurl(filePath, version string) string {
	return fmt.Sprintf("pkg:generic/%s@%s", filePath, version)
}

func getDescription(query *model.QueryResult, format string) string {
	queryDescription := query.Description

	if query.CISDescriptionTextFormatted != "" {
		queryDescription = query.CISDescriptionTextFormatted
	}

	if format == "asff" {
		return queryDescription
	}

	description := fmt.Sprintf("[%s].[%s]: %s", query.Platform, query.QueryName, queryDescription)

	return description
}

func getVulnerabilitiesByFile(query *model.QueryResult, fileName, purl string) []Vulnerability {
	vulns := make([]Vulnerability, 0)
	for idx := range query.Files {
		file := query.Files[idx]
		if fileName == file.FileName {
			vuln := Vulnerability{
				Ref: purl + query.QueryID,
				ID:  query.QueryID,
				CWE: query.CWE,
				Source: Source{
					Name: "KICS",
					URL:  "https://kics.io/",
				},
				Ratings: []Rating{
					{
						Severity: cycloneDxSeverityLevelEquivalence[query.Severity],
						Method:   "Other",
					},
				},
				Description: getDescription(query, "cyclonedx"),
				Recommendations: []Recommendation{
					{
						Recommendation: fmt.Sprintf(
							"Problem found in line %d. Expected value: %s. Actual value: %s.",
							file.Line,
							strings.TrimRight(file.KeyExpectedValue, "."),
							strings.TrimRight(file.KeyActualValue, "."),
						),
					},
				},
			}
			vulns = append(vulns, vuln)
		}
	}
	return vulns
}

func getVulnerabilities(fileName, purl string, summary *model.Summary) []Vulnerability {
	vulns := make([]Vulnerability, 0)
	for i := range summary.Queries {
		query := summary.Queries[i]
		vulns = append(vulns, getVulnerabilitiesByFile(&query, fileName, purl)...)
	}
	return vulns
}

// InitCycloneDxReport inits the CycloneDx report with no components (consequently, no vulnerabilities)
func InitCycloneDxReport() *CycloneDxReport {
	metadata := Metadata{
		Timestamp: time.Now().Format(time.RFC3339),
		Tools: &[]Tool{
			{
				Vendor:  "Checkmarx",
				Name:    "KICS",
				Version: constants.Version,
			},
		},
	}

	return &CycloneDxReport{
		XMLNS:        "http://cyclonedx.org/schema/bom/1.5",
		XMLNSV:       "http://cyclonedx.org/schema/ext/vulnerability/1.0",
		SerialNumber: "urn:uuid:" + uuid.New().String(),
		Version:      1,
		Metadata:     &metadata,
	}
}

// BuildCycloneDxReport builds the CycloneDX report
func BuildCycloneDxReport(summary *model.Summary, filePaths map[string]string) *CycloneDxReport {
	var component Component
	var vuln []Vulnerability
	var version, sha, purl, filePath string

	bom := InitCycloneDxReport()
	files := getAllFiles(summary)

	for i := range files {
		filePath = strings.ReplaceAll(files[i].FileName, "\\", "/")
		sha = generateSha256(files[i].FileName, filePaths)

		index := 12
		if len(sha) < index {
			log.Trace().Msgf("failed to generate SHA-256 for %s", filePath)
			continue
		}

		version = fmt.Sprintf("0.0.0-%s", sha[0:12])
		purl = getPurl(filePath, version)
		vuln = getVulnerabilities(files[i].FileName, purl, summary)

		component = Component{
			Type:    "file",
			BomRef:  purl,
			Name:    filePath,
			Version: version,
			Purl:    purl,
			Hashes: []Hash{
				{
					Alg:     "SHA-256",
					Content: sha,
				},
			},
			Vulnerabilities: vuln,
		}

		bom.Components.Components = append(bom.Components.Components, component)
	}

	return bom
}

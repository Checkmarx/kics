package model

import (
	"fmt"
	"path/filepath"
	"strings"
	"time"

	"github.com/Checkmarx/kics/internal/constants"
	"github.com/Checkmarx/kics/pkg/model"
	"github.com/rs/zerolog/log"
)

const timeFormat = "2006-01-02T15:04:05" // YYYY-MM-DDTHH:MM:SS a.k.a ISO8601

type gitlabSASTReport struct {
	basePath        string                    `json:"-"`
	Schema          string                    `json:"schema"`
	SchemaVersion   string                    `json:"version"`
	Scan            gitlabSASTScan            `json:"scan"`
	Vulnerabilities []gitlabSASTVulnerability `json:"vulnerabilities"`
}

type gitlabSASTScan struct {
	StartTime string            `json:"start_time"`
	EndTime   string            `json:"end_time"`
	Status    string            `json:"status"`
	Scantype  string            `json:"type"`
	Scanner   gitlabSASTScanner `json:"scanner"`
}

type gitlabSASTScanner struct {
	ID      string                  `json:"id"`
	Name    string                  `json:"name"`
	URL     string                  `json:"url"`
	Version string                  `json:"version"`
	Vendor  gitlabSASTScannerVendor `json:"vendor"`
}

type gitlabSASTScannerVendor struct {
	Name string `json:"name"`
}

type gitlabSASTVulnerability struct {
	ID          string                              `json:"id"`
	Category    string                              `json:"category"`
	Severity    string                              `json:"severity"`
	CVE         string                              `json:"cve"`
	Scanner     gitlabSASTVulnerabilityScanner      `json:"scanner"`
	Name        string                              `json:"name"`
	Message     string                              `json:"message"`
	Links       []gitlabSASTVulnerabilityLink       `json:"links"`
	Location    gitlabSASTVulnerabilityLocation     `json:"location"`
	Identifiers []gitlabSASTVulnerabilityIdentifier `json:"identifiers"`
}

type gitlabSASTVulnerabilityScanner struct {
	ID   string `json:"id"`
	Name string `json:"name"`
}

type gitlabSASTVulnerabilityLink struct {
	URL string `json:"url"`
}

type gitlabSASTVulnerabilityLocation struct {
	File  string `json:"file"`
	Start int    `json:"start_line"`
	End   int    `json:"end_line"`
}

type gitlabSASTVulnerabilityIdentifier struct {
	IdentifierType string `json:"type"`
	Name           string `json:"name"`
	URL            string `json:"url"`
	Value          string `json:"value"`
}

// GitlabSASTReport represents a usable gitlab sast report reference
type GitlabSASTReport interface {
	BuildGitlabSASTVulnerability(issue *model.VulnerableQuery, file *model.VulnerableFile)
}

// NewGitlabSASTReport initializes a new instance of GitlabSASTReport to be uses
func NewGitlabSASTReport(start, end time.Time) GitlabSASTReport {
	return &gitlabSASTReport{
		Schema:          "https://gitlab.com/gitlab-org/security-products/security-report-schemas/-/raw/v13.1.0/dist/sast-report-format.json",
		SchemaVersion:   "13.1.0",
		Scan:            initGitlabSASTScan(start, end),
		Vulnerabilities: make([]gitlabSASTVulnerability, 0),
	}
}

func initGitlabSASTScan(start, end time.Time) gitlabSASTScan {
	return gitlabSASTScan{
		Status:    "success",
		Scantype:  "sast",
		StartTime: start.Format(timeFormat),
		EndTime:   end.Format(timeFormat),
		Scanner: gitlabSASTScanner{
			ID:   "keeping-infrastructure-as-code-secure",
			Name: constants.Fullname,
			URL:  constants.URL,
			Vendor: gitlabSASTScannerVendor{
				Name: "Checkmarx",
			},
			Version: constants.Version,
		},
	}
}

// BuildGitlabSASTVulnerability adds a new vulnerability struct to vulnerability slice
func (glsr *gitlabSASTReport) BuildGitlabSASTVulnerability(issue *model.VulnerableQuery, file *model.VulnerableFile) {
	if len(issue.Files) > 0 {
		absBasePath, err := filepath.Abs(glsr.basePath)
		if err != nil {
			log.Err(err)
		}
		relativePath, err := filepath.Rel(absBasePath, file.FileName)
		if err != nil {
			log.Err(err)
		}

		vulnerability := gitlabSASTVulnerability{
			ID:       file.SimilarityID,
			Category: issue.Category,
			Severity: strings.ToLower(string(issue.Severity)),
			CVE:      file.SimilarityID,
			Scanner: gitlabSASTVulnerabilityScanner{
				ID:   "keeping_infrastructure_as_code_secure",
				Name: constants.Fullname,
			},
			Name:    issue.QueryName,
			Message: issue.Description,
			Links: []gitlabSASTVulnerabilityLink{
				{
					URL: issue.QueryURI,
				},
			},
			Location: gitlabSASTVulnerabilityLocation{
				File:  relativePath,
				Start: file.Line,
				End:   file.Line,
			},
			Identifiers: []gitlabSASTVulnerabilityIdentifier{
				{
					IdentifierType: "kics",
					Name:           constants.Fullname,
					URL:            fmt.Sprintf("https://docs.kics.io/latest/queries/%s-queries", strings.ToLower(issue.Platform)),
					Value:          issue.QueryID,
				},
			},
		}
		glsr.Vulnerabilities = append(glsr.Vulnerabilities, vulnerability)
	}
}

package model

import (
	"github.com/Checkmarx/kics/v2/internal/constants"
	"github.com/Checkmarx/kics/v2/pkg/model"
)

// severitySonarQubeEquivalence maps the severity of the KICS to the SonarQube equivalent
var severitySonarQubeEquivalence = map[model.Severity]string{
	"INFO":     "INFO",
	"LOW":      "MINOR",
	"MEDIUM":   "MAJOR",
	"HIGH":     "CRITICAL",
	"CRITICAL": "BLOCKER",
}

// categorySonarQubeEquivalence maps the category to the SonarQube equivalent
var categorySonarQubeEquivalence = map[string]string{
	"Access Control":          "VULNERABILITY",
	"Availability":            "VULNERABILITY",
	"Backup":                  "VULNERABILITY",
	"Best Practices":          "CODE_SMELL",
	"Build Process":           "VULNERABILITY",
	"Encryption":              "VULNERABILITY",
	"Insecure Configurations": "CODE_SMELL",
	"Insecure Defaults":       "CODE_SMELL",
	"Networking and Firewall": "VULNERABILITY",
	"Observability":           "VULNERABILITY",
	"Resource Management":     "VULNERABILITY",
	"Secret Management":       "VULNERABILITY",
	"Supply-Chain":            "VULNERABILITY",
	"Structure and Semantics": "CODE_SMELL",
}

var cleanCodeAttributeSonarQubeEquivalence = map[string]string{
	"BUG":           "LOGICAL",
	"CODE_SMELL":    "CONVENTIONAL",
	"VULNERABILITY": "TRUSTWORTHY",
}

var softwareQualitySonarQubeEquivalence = map[string]string{
	"BUG":           "RELIABILITY",
	"CODE_SMELL":    "MAINTAINABILITY",
	"VULNERABILITY": "SECURITY",
}

var impactSeveritySonarQubeEquivalence = map[string]string{
	"BLOCKER":  "BLOCKER",
	"CRITICAL": "HIGH",
	"MAJOR":    "MEDIUM",
	"MINOR":    "LOW",
	"INFO":     "INFO",
}

// SonarQubeReportBuilder is the builder for the SonarQubeReport struct
type SonarQubeReportBuilder struct {
	version string
	report  *SonarQubeReport
}

// SonarQubeReport is a list of rules and issues for SonarQube Report
type SonarQubeReport struct {
	Rules  []Rule  `json:"rules"`
	Issues []Issue `json:"issues"`
}

// Rule is a single rule for SonarQube Report
type Rule struct {
	ID                 string   `json:"id"`
	Name               string   `json:"name"`
	Description        string   `json:"description"`
	EngineID           string   `json:"engineId"`
	CleanCodeAttribute string   `json:"cleanCodeAttribute"`
	Type               string   `json:"type"`
	Severity           string   `json:"severity"`
	Impacts            []Impact `json:"impacts"`
}

// Impact is a software quality impact for SonarQube Report
type Impact struct {
	SoftwareQuality string `json:"softwareQuality"`
	Severity        string `json:"severity"`
}

// Issue is a single issue for SonarQube Report
type Issue struct {
	RuleID             string      `json:"ruleId"`
	EffortMinutes      int         `json:"effortMinutes,omitempty"`
	PrimaryLocation    *Location   `json:"primaryLocation"`
	SecondaryLocations []*Location `json:"secondaryLocations,omitempty"`
}

// Location is the location for the vulnerability in the SonarQube Report
type Location struct {
	Message   string `json:"message"`
	FilePath  string `json:"filePath"`
	TextRange *Range `json:"textRange"`
}

// Range is the range for the vulnerability in the SonarQube Report
type Range struct {
	StartLine int `json:"startLine"`
}

// NewSonarQubeRepory creates a new SonarQubeReportBuilder instance
func NewSonarQubeRepory() *SonarQubeReportBuilder {
	return &SonarQubeReportBuilder{
		version: "KICS " + constants.Version,
		report: &SonarQubeReport{
			Rules:  make([]Rule, 0),
			Issues: make([]Issue, 0),
		},
	}
}

// BuildReport builds the SonarQubeReport from the given QueryResults
func (s *SonarQubeReportBuilder) BuildReport(summary *model.Summary) *SonarQubeReport {
	for i := range summary.Queries {
		s.buildRule(&summary.Queries[i])
		s.buildIssue(&summary.Queries[i])
	}
	return s.report
}

func (s *SonarQubeReportBuilder) buildRule(query *model.QueryResult) {
	ruleType := getRuleType(query.Category)
	severity := severitySonarQubeEquivalence[query.Severity]

	s.report.Rules = append(s.report.Rules, Rule{
		ID:                 query.QueryID,
		Name:               getRuleName(query),
		Description:        getRuleDescription(query),
		EngineID:           s.version,
		CleanCodeAttribute: cleanCodeAttributeSonarQubeEquivalence[ruleType],
		Type:               ruleType,
		Severity:           severity,
		Impacts: []Impact{
			{
				SoftwareQuality: softwareQualitySonarQubeEquivalence[ruleType],
				Severity:        impactSeveritySonarQubeEquivalence[severity],
			},
		},
	})
}

// buildIssue builds the issue from the given QueryResult and adds it to the SonarQubeReport
func (s *SonarQubeReportBuilder) buildIssue(query *model.QueryResult) {
	issue := Issue{
		RuleID:             query.QueryID,
		PrimaryLocation:    buildLocation(0, query),
		SecondaryLocations: buildSecondaryLocation(query),
	}
	s.report.Issues = append(s.report.Issues, issue)
}

func getRuleType(category string) string {
	ruleType := categorySonarQubeEquivalence[category]
	if ruleType == "" {
		return "VULNERABILITY"
	}
	return ruleType
}

func getRuleName(query *model.QueryResult) string {
	if query.QueryName != "" {
		return query.QueryName
	}
	return query.QueryID
}

func getRuleDescription(query *model.QueryResult) string {
	if query.Description != "" {
		return query.Description
	}
	return getRuleName(query)
}

// buildSecondaryLocation builds the secondary location for the SonarQube Report
func buildSecondaryLocation(query *model.QueryResult) []*Location {
	locations := make([]*Location, 0)
	for i := range query.Files[1:] {
		locations = append(locations, buildLocation(i+1, query))
	}
	return locations
}

// buildLocation builds the location for the SonarQube Report
func buildLocation(index int, query *model.QueryResult) *Location {
	message := query.Description
	if query.CISDescriptionID != "" {
		message = query.CISDescriptionID
	}
	return &Location{
		Message:  message,
		FilePath: query.Files[index].FileName,
		TextRange: &Range{
			StartLine: query.Files[index].Line,
		},
	}
}

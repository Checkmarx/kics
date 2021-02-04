package model

import (
	"fmt"

	"github.com/Checkmarx/kics/internal/console"
)

var severityLevelEquivalence = map[Severity]string{
	"INFO":   "none",
	"LOW":    "note",
	"MEDIUM": "warning",
	"HIGH":   "error",
}
var currentRuleIndex = 0

var noCategory = sarifTaxanomyDefinition{
	DefinitionID:               "CAT000",
	DefinitionName:             "Undefined Category",
	DefinitionShortDescription: sarifMessage{Text: "Category is not defined"},
	DefinitionFullDescription:  sarifMessage{Text: "Category is not defined"},
}

var targetTemplate = sarifDescriptorReference{
	ToolComponent: sarifComponentReference{
		ComponentReferenceGUID:  "58cdcc6f-fe41-4724-bfb3-131a93df4c3f",
		ComponentReferenceName:  "Categories",
		ComponentReferenceIndex: 0,
	},
}

type ruleMetadata struct {
	queryID          string
	queryName        string
	queryDescription string
	queryURI         string
	queryCategory    string
	severity         Severity
}

type sarifMessage struct {
	Text string `json:"text"`
}

type sarifComponentReference struct {
	ComponentReferenceName  string `json:"name"`
	ComponentReferenceGUID  string `json:"guid"`
	ComponentReferenceIndex int    `json:"index"`
}

type sarifDescriptorReference struct {
	ReferenceID    string                  `json:"id"`
	ReferenceIndex int                     `json:"index"`
	ToolComponent  sarifComponentReference `json:"toolComponent"`
}

type sarifDescriptorRelationship struct {
	Target sarifDescriptorReference `json:"target"`
}

type sarifConfiguration struct {
	Level string `json:"level"`
}

type sarifRule struct {
	RuleID               string                        `json:"id"`
	RuleName             string                        `json:"name"`
	RuleShortDescription sarifMessage                  `json:"shortDescription"`
	RuleFullDescription  sarifMessage                  `json:"fullDescription"`
	DefaultConfiguration sarifConfiguration            `json:"defaultConfiguration"`
	HelpURI              string                        `json:"helpUri"`
	RuleRelationships    []sarifDescriptorRelationship `json:"relationships"`
}

type sarifDriver struct {
	ToolName     string      `json:"name"`
	ToolVersion  string      `json:"version"`
	ToolFullName string      `json:"fullName"`
	ToolURI      string      `json:"informationUri"`
	Rules        []sarifRule `json:"rules"`
}

type sarifTool struct {
	Driver sarifDriver `json:"driver"`
}

type sarifRegion struct {
	StartLine int `json:"startLine"`
}

type sarifArtifactLocation struct {
	ArtifactURI string `json:"uri"`
}

type sarifPhysicalLocation struct {
	ArtifactLocation sarifArtifactLocation `json:"artifactLocation"`
	Region           sarifRegion           `json:"region"`
}

type sarifLocation struct {
	PhysicalLocation sarifPhysicalLocation `json:"physicalLocation"`
}

type sarifResult struct {
	ResultRuleID    string          `json:"ruleId"`
	ResultRuleIndex int             `json:"ruleIndex"`
	ResultKind      string          `json:"kind"`
	ResultMessage   sarifMessage    `json:"message"`
	ResultLocations []sarifLocation `json:"locations"`
}

type sarifTaxanomyDefinition struct {
	DefinitionID               string       `json:"id"`
	DefinitionName             string       `json:"name"`
	DefinitionShortDescription sarifMessage `json:"shortDescription"`
	DefinitionFullDescription  sarifMessage `json:"fullDescription"`
}

type sarifTaxonomy struct {
	TaxonomyGUID             string                    `json:"guid"`
	TaxonomyName             string                    `json:"name"`
	TaxonomyShortDescription sarifMessage              `json:"shortDescription"`
	TaxonomyDefinitions      []sarifTaxanomyDefinition `json:"taxa"`
}

type sarifRun struct {
	Tool       sarifTool       `json:"tool"`
	Results    []sarifResult   `json:"results"`
	Taxonomies []sarifTaxonomy `json:"taxonomies"`
}

type SarifReport struct {
	Schema       string     `json:"$schema"`
	SarifVersion string     `json:"version"`
	Runs         []sarifRun `json:"runs"`
}

func initTool() sarifTool {
	return sarifTool{
		Driver: sarifDriver{
			ToolName:     "KICS",
			ToolVersion:  console.CurrentKICSVersion,
			ToolFullName: console.CurrentKICSFullname,
			ToolURI:      "https://www.kics.io/",
			Rules:        make([]sarifRule, 0),
		},
	}
}

func initTaxonomies() []sarifTaxonomy {
	return []sarifTaxonomy{
		{
			TaxonomyGUID: targetTemplate.ToolComponent.ComponentReferenceGUID,
			TaxonomyName: targetTemplate.ToolComponent.ComponentReferenceName,
			TaxonomyShortDescription: sarifMessage{
				Text: "Vulnerabilities categories",
			},
			TaxonomyDefinitions: []sarifTaxanomyDefinition{noCategory},
		},
	}
}

func initRun() []sarifRun {
	return []sarifRun{
		{
			Tool:       initTool(),
			Results:    make([]sarifResult, 0),
			Taxonomies: initTaxonomies(),
		},
	}
}

func NewSarifReport() *SarifReport {
	return &SarifReport{
		Schema:       "https://raw.githubusercontent.com/oasis-tcs/sarif-spec/master/Schemata/sarif-schema-2.1.0.json",
		SarifVersion: "2.1.0",
		Runs:         initRun(),
	}
}

func (sr *SarifReport) findCategory(category string) int {
	for idx, taxonomy := range sr.Runs[0].Taxonomies[0].TaxonomyDefinitions {
		if taxonomy.DefinitionName == category {
			return idx
		}
	}
	return -1
}

func (sr *SarifReport) buildCategory(category string) sarifDescriptorReference {
	target := targetTemplate
	categoryIndex := sr.findCategory(category)
	if categoryIndex == -1 {
		if category == "" {
			categoryIndex = 0
		} else {
			categoryIndex = len(sr.Runs[0].Taxonomies[0].TaxonomyDefinitions)
			sr.Runs[0].Taxonomies[0].TaxonomyDefinitions = append(sr.Runs[0].Taxonomies[0].TaxonomyDefinitions,
				sarifTaxanomyDefinition{
					DefinitionID:               fmt.Sprintf("CAT%03d", categoryIndex),
					DefinitionName:             category,
					DefinitionShortDescription: sarifMessage{Text: "Vulnerability category"},
					DefinitionFullDescription:  sarifMessage{Text: "Vulnerability category"},
				})
		}
	}
	target.ReferenceIndex = categoryIndex
	target.ReferenceID = sr.Runs[0].Taxonomies[0].TaxonomyDefinitions[categoryIndex].DefinitionID
	return target
}

func (sr *SarifReport) findRuleIndex(ruleID string) int {
	for idx, rule := range sr.Runs[0].Tool.Driver.Rules {
		if rule.RuleID == ruleID {
			return idx
		}
	}
	return -1
}

func (sr *SarifReport) buildRule(queryMetadata *ruleMetadata) int {
	index := sr.findRuleIndex(queryMetadata.queryID)
	if index < 0 {
		rule := sarifRule{
			RuleID:               queryMetadata.queryID,
			RuleName:             queryMetadata.queryName,
			RuleShortDescription: sarifMessage{Text: queryMetadata.queryName},
			RuleFullDescription:  sarifMessage{Text: queryMetadata.queryDescription},
			DefaultConfiguration: sarifConfiguration{Level: severityLevelEquivalence[queryMetadata.severity]},
			RuleRelationships:    []sarifDescriptorRelationship{{Target: sr.buildCategory(queryMetadata.queryCategory)}},
			HelpURI:              queryMetadata.queryURI,
		}

		sr.Runs[0].Tool.Driver.Rules = append(sr.Runs[0].Tool.Driver.Rules, rule)
		index = currentRuleIndex
		currentRuleIndex++
	}
	return index
}

func (sr *SarifReport) BuildIssue(issue *VulnerableQuery) {
	metadata := ruleMetadata{
		queryID:          issue.QueryID,
		queryName:        issue.QueryName,
		queryDescription: issue.QueryDescription,
		queryURI:         issue.QueryURI,
		queryCategory:    issue.QueryCategory,
		severity:         issue.Severity,
	}
	ruleIndex := sr.buildRule(&metadata)
	kind := "fail"
	if severityLevelEquivalence[issue.Severity] == "none" {
		kind = "informational"
	}
	for idx := range issue.Files {
		result := sarifResult{
			ResultRuleID:    issue.QueryID,
			ResultRuleIndex: ruleIndex,
			ResultKind:      kind,
			ResultMessage:   sarifMessage{Text: issue.Files[idx].KeyActualValue},
			ResultLocations: []sarifLocation{
				{
					PhysicalLocation: sarifPhysicalLocation{
						ArtifactLocation: sarifArtifactLocation{ArtifactURI: issue.Files[idx].FileName},
						Region:           sarifRegion{StartLine: issue.Files[idx].Line},
					},
				},
			},
		}
		sr.Runs[0].Results = append(sr.Runs[0].Results, result)
	}
}

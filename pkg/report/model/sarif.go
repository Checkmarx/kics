package model

import (
	"github.com/Checkmarx/kics/internal/constants"
	"github.com/Checkmarx/kics/pkg/model"
	"github.com/rs/zerolog/log"
)

var categoriesNotFound = make(map[string]bool)

var severityLevelEquivalence = map[model.Severity]string{
	"INFO":   "none",
	"LOW":    "note",
	"MEDIUM": "warning",
	"HIGH":   "error",
}

var targetTemplate = sarifDescriptorReference{
	ToolComponent: sarifComponentReference{
		ComponentReferenceGUID:  "58cdcc6f-fe41-4724-bfb3-131a93df4c3f",
		ComponentReferenceName:  "Categories",
		ComponentReferenceIndex: 0,
	},
}

type sarifProperties map[string]interface{}

type ruleMetadata struct {
	queryID          string
	queryName        string
	queryDescription string
	queryURI         string
	queryCategory    string
	severity         model.Severity
}

type ruleCISMetadata struct {
	descriptionText string
	id              string
	title           string
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
	RuleProperties       sarifProperties               `json:"properties,omitempty"`
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
	TaxonomyFullDescription  sarifMessage              `json:"fullDescription"`
	TaxonomyShortDescription sarifMessage              `json:"shortDescription"`
	TaxonomyDefinitions      []sarifTaxanomyDefinition `json:"taxa"`
}

// SarifRun - sarifRun is a component of the SARIF report
type SarifRun struct {
	Tool       sarifTool       `json:"tool"`
	Results    []sarifResult   `json:"results"`
	Taxonomies []sarifTaxonomy `json:"taxonomies"`
}

// SarifReport represents a usable sarif report reference
type SarifReport interface {
	BuildSarifIssue(issue *model.VulnerableQuery)
}

type sarifReport struct {
	Schema       string     `json:"$schema"`
	SarifVersion string     `json:"version"`
	Runs         []SarifRun `json:"runs"`
}

func initSarifTool() sarifTool {
	return sarifTool{
		Driver: sarifDriver{
			ToolName:     "KICS",
			ToolVersion:  constants.Version,
			ToolFullName: constants.Fullname,
			ToolURI:      constants.URL,
			Rules:        make([]sarifRule, 0),
		},
	}
}

func initSarifCategories() []sarifTaxanomyDefinition {
	allCategories := []sarifTaxanomyDefinition{noCategory}
	for _, category := range categories {
		allCategories = append(allCategories, category)
	}
	return allCategories
}

func initSarifTaxonomies() []sarifTaxonomy {
	return []sarifTaxonomy{
		{
			TaxonomyGUID: targetTemplate.ToolComponent.ComponentReferenceGUID,
			TaxonomyName: targetTemplate.ToolComponent.ComponentReferenceName,
			TaxonomyShortDescription: sarifMessage{
				Text: "Vulnerabilities categories",
			},
			TaxonomyFullDescription: sarifMessage{
				Text: "This taxonomy contains the types an issue can assume",
			},
			TaxonomyDefinitions: initSarifCategories(),
		},
	}
}

func initSarifRun() []SarifRun {
	return []SarifRun{
		{
			Tool:       initSarifTool(),
			Results:    make([]sarifResult, 0),
			Taxonomies: initSarifTaxonomies(),
		},
	}
}

// NewSarifReport creates and start a new sarif report with default values respecting SARIF schema 2.1.0
func NewSarifReport() SarifReport {
	return &sarifReport{
		Schema:       "https://raw.githubusercontent.com/oasis-tcs/sarif-spec/master/Schemata/sarif-schema-2.1.0.json",
		SarifVersion: "2.1.0",
		Runs:         initSarifRun(),
	}
}

func (sr *sarifReport) findSarifCategory(category string) int {
	for idx, taxonomy := range sr.Runs[0].Taxonomies[0].TaxonomyDefinitions {
		if taxonomy.DefinitionName == category {
			return idx
		}
	}
	return 0
}

func (sr *sarifReport) buildSarifCategory(category string) sarifDescriptorReference {
	target := targetTemplate
	categoryIndex := sr.findSarifCategory(category)
	target.ReferenceIndex = categoryIndex
	target.ReferenceID = sr.Runs[0].Taxonomies[0].TaxonomyDefinitions[categoryIndex].DefinitionID
	if categoryIndex == 0 {
		if _, exists := categoriesNotFound[category]; !exists {
			log.Warn().Msgf("Category %s not found.", category)
			categoriesNotFound[category] = true
		}
	}
	return target
}

func (sr *sarifReport) findSarifRuleIndex(ruleID string) int {
	for idx := range sr.Runs[0].Tool.Driver.Rules {
		if sr.Runs[0].Tool.Driver.Rules[idx].RuleID == ruleID {
			return idx
		}
	}
	return -1
}

func (sr *sarifReport) buildSarifRule(queryMetadata *ruleMetadata, cisMetadata ruleCISMetadata) int {
	index := sr.findSarifRuleIndex(queryMetadata.queryID)
	if index < 0 {
		helpURI := "https://docs.kics.io/"
		if queryMetadata.queryURI != "" {
			helpURI = queryMetadata.queryURI
		}
		rule := sarifRule{
			RuleID:               queryMetadata.queryID,
			RuleName:             queryMetadata.queryName,
			RuleShortDescription: sarifMessage{Text: queryMetadata.queryName},
			RuleFullDescription:  sarifMessage{Text: queryMetadata.queryDescription},
			DefaultConfiguration: sarifConfiguration{Level: severityLevelEquivalence[queryMetadata.severity]},
			RuleRelationships:    []sarifDescriptorRelationship{{Target: sr.buildSarifCategory(queryMetadata.queryCategory)}},
			HelpURI:              helpURI,
			RuleProperties:       nil,
		}
		if cisMetadata.id != "" {
			rule.RuleFullDescription.Text = cisMetadata.descriptionText
			rule.RuleProperties = sarifProperties{
				"cisId":    cisMetadata.id,
				"cisTitle": cisMetadata.title,
			}
		}

		sr.Runs[0].Tool.Driver.Rules = append(sr.Runs[0].Tool.Driver.Rules, rule)
		index = len(sr.Runs[0].Tool.Driver.Rules) - 1
	}
	return index
}

// BuildSarifIssue creates a new entries in Results (one for each file) and new entry in Rules and Taxonomy if necessary
func (sr *sarifReport) BuildSarifIssue(issue *model.VulnerableQuery) {
	if len(issue.Files) > 0 {
		metadata := ruleMetadata{
			queryID:          issue.QueryID,
			queryName:        issue.QueryName,
			queryDescription: issue.Description,
			queryURI:         issue.QueryURI,
			queryCategory:    issue.Category,
			severity:         issue.Severity,
		}
		cisDescriptions := ruleCISMetadata{
			id:              issue.CISDescriptionIDFormatted,
			title:           issue.CISDescriptionTitle,
			descriptionText: issue.CISDescriptionTextFormatted,
		}
		ruleIndex := sr.buildSarifRule(&metadata, cisDescriptions)

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
}

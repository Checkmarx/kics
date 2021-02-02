package model

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
	FullDescription      sarifMessage                  `json:"fullDescription"`
	DefaultConfiguration sarifConfiguration            `json:"defaultConfiguration"`
	Relationships        []sarifDescriptorRelationship `json:"relationships"`
	HelpURI              string                        `json:"helpUri"`
}

type sarifDriver struct {
	ToolName     string      `json:"name"`
	ToolVersion  string      `json:"version"`
	ToolFullName string      `json:"fullName"`
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
	Definitions              []sarifTaxanomyDefinition `json:"taxa"`
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

func initTaxonomies() []sarifTaxonomy {
	return []sarifTaxonomy{
		{
			TaxonomyGUID: "58cdcc6f-fe41-4724-bfb3-131a93df4c3f",
			TaxonomyName: "Categories",
			TaxonomyShortDescription: sarifMessage{
				Text: "Vulnerabilities categories",
			},
			Definitions: []sarifTaxanomyDefinition{
				{
					DefinitionID:               "CAT0001",
					DefinitionName:             "Logging",
					DefinitionShortDescription: sarifMessage{Text: "ShortDescription"},
					DefinitionFullDescription:  sarifMessage{Text: "FullDescription"},
				},
			},
		},
	}
}

func initTool() sarifTool {
	return sarifTool{
		Driver: sarifDriver{
			ToolName:     "KICS",
			ToolVersion:  "1.1.2",
			ToolFullName: "Keeping Infrastructure as Code Secure v1.1.2",
			Rules:        make([]sarifRule, 1),
		},
	}
}

func initRun() []sarifRun {
	return []sarifRun{
		{
			Tool:       initTool(),
			Results:    make([]sarifResult, 1),
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

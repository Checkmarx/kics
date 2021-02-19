package model

const categoryIdentifier = "CAT"

var noCategory = sarifTaxanomyDefinition{
	DefinitionID:               categoryIdentifier + "000",
	DefinitionName:             "Undefined Category",
	DefinitionShortDescription: sarifMessage{Text: "Category is not defined"},
	DefinitionFullDescription:  sarifMessage{Text: "Category is not defined"},
}

var categories = map[string]sarifTaxanomyDefinition{
	"Backup and Disaster Recovery": {
		DefinitionID:   categoryIdentifier + "001",
		DefinitionName: "Backup and Disaster Recovery",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Cloud Assets Management": {
		DefinitionID:   categoryIdentifier + "002",
		DefinitionName: "Cloud Assets Management",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Domain Name System (DNS)": {
		DefinitionID:   categoryIdentifier + "003",
		DefinitionName: "Domain Name System (DNS)",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Encryption and Key Management": {
		DefinitionID:   categoryIdentifier + "004",
		DefinitionName: "Encryption and Key Management",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Identity and Access Management": {
		DefinitionID:   categoryIdentifier + "005",
		DefinitionName: "Identity and Access Management",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Logging": {
		DefinitionID:   categoryIdentifier + "006",
		DefinitionName: "Logging",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Management": {
		DefinitionID:   categoryIdentifier + "007",
		DefinitionName: "Management",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Monitoring": {
		DefinitionID:   categoryIdentifier + "008",
		DefinitionName: "Monitoring",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Network Ports Security": {
		DefinitionID:   categoryIdentifier + "009",
		DefinitionName: "Network Ports Security",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Network Security": {
		DefinitionID:   categoryIdentifier + "010",
		DefinitionName: "Network Security",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Operational": {
		DefinitionID:   categoryIdentifier + "011",
		DefinitionName: "Operational",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Resources Limiting": {
		DefinitionID:   categoryIdentifier + "012",
		DefinitionName: "Resources Limiting",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Vulnerability and Threat Management": {
		DefinitionID:   categoryIdentifier + "013",
		DefinitionName: "Vulnerability and Threat Management",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
}

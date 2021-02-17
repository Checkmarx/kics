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
		DefinitionName: "Backup and Disaster Recovery",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Cloud Assets Management": {
		DefinitionName: "Cloud Assets Management",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Domain Name System (DNS)": {
		DefinitionName: "Domain Name System (DNS)",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Encryption and Key Management": {
		DefinitionName: "Encryption and Key Management",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Identity and Access Management": {
		DefinitionName: "Identity and Access Management",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Logging": {
		DefinitionName: "Logging",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Management": {
		DefinitionName: "Management",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Monitoring": {
		DefinitionName: "Monitoring",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Network Ports Security": {
		DefinitionName: "Network Ports Security",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Network Security": {
		DefinitionName: "Network Security",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Operational": {
		DefinitionName: "Operational",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Resources Limiting": {
		DefinitionName: "Resources Limiting",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Vulnerability and Threat Management": {
		DefinitionName: "Vulnerability and Threat Management",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
}

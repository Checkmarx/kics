package model

const categoryIdentifier = "CAT"

var noCategory = sarifTaxanomyDefinition{
	DefinitionID:               categoryIdentifier + "000",
	DefinitionName:             "Undefined Category",
	DefinitionShortDescription: sarifMessage{Text: "Category is not defined"},
	DefinitionFullDescription:  sarifMessage{Text: "Category is not defined"},
}

var categories = map[string]sarifTaxanomyDefinition{
	"Access Control": {
		DefinitionID:   categoryIdentifier + "001",
		DefinitionName: "Access Control",
		DefinitionShortDescription: sarifMessage{
			Text: "Service permission and identity management",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Service permission and identity management",
		},
	},
	"Availability": {
		DefinitionID:   categoryIdentifier + "002",
		DefinitionName: "Availability",
		DefinitionShortDescription: sarifMessage{
			Text: "Reliability and Scalability",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Reliability and Scalability",
		},
	},
	"Backup": {
		DefinitionID:   categoryIdentifier + "003",
		DefinitionName: "Backup",
		DefinitionShortDescription: sarifMessage{
			Text: "Survivability and Recovery",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Survivability and Recovery",
		},
	},
	"Best Practices": {
		DefinitionID:   categoryIdentifier + "004",
		DefinitionName: "Best Practices",
		DefinitionShortDescription: sarifMessage{
			Text: "Metadata management",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Metadata management",
		},
	},
	"Build Process": {
		DefinitionID:   categoryIdentifier + "005",
		DefinitionName: "Build Process",
		DefinitionShortDescription: sarifMessage{
			Text: "Insecure configurations when building/deploying Docker images",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Insecure configurations when building/deploying Docker images",
		},
	},
	"Encryption": {
		DefinitionID:   categoryIdentifier + "006",
		DefinitionName: "Encryption",
		DefinitionShortDescription: sarifMessage{
			Text: "Data Security and Encryption configuration",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Data Security and Encryption configuration",
		},
	},
	"Insecure Configurations": {
		DefinitionID:   categoryIdentifier + "007",
		DefinitionName: "Insecure Configurations",
		DefinitionShortDescription: sarifMessage{
			Text: "Configurations which expose the application unnecessarily",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Configurations which expose the application unnecessarily",
		},
	},
	"Insecure Defaults": {
		DefinitionID:   categoryIdentifier + "008",
		DefinitionName: "Insecure Defaults",
		DefinitionShortDescription: sarifMessage{
			Text: "Configurations that are insecure by default",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Configurations that are insecure by default",
		},
	},
	"Networking and Firewall": {
		DefinitionID:   categoryIdentifier + "009",
		DefinitionName: "Networking and Firewall",
		DefinitionShortDescription: sarifMessage{
			Text: "Network port exposure and firewall configuration",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Network port exposure and firewall configuration",
		},
	},
	"Observability": {
		DefinitionID:   categoryIdentifier + "010",
		DefinitionName: "Observability",
		DefinitionShortDescription: sarifMessage{
			Text: "Logging and Monitoring",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Logging and Monitoring",
		},
	},
	"Resource Management": {
		DefinitionID:   categoryIdentifier + "011",
		DefinitionName: "Resource Management",
		DefinitionShortDescription: sarifMessage{
			Text: "Resource and privilege limit configuration",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Resource and privilege limit configuration",
		},
	},
	"Secret Management": {
		DefinitionID:   categoryIdentifier + "012",
		DefinitionName: "Secret Management",
		DefinitionShortDescription: sarifMessage{
			Text: "Secret and Key management",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Secret and Key management",
		},
	},
	"Supply-Chain": {
		DefinitionID:   categoryIdentifier + "013",
		DefinitionName: "Supply-Chain",
		DefinitionShortDescription: sarifMessage{
			Text: "Dependency version management",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Dependency version management",
		},
	},
}

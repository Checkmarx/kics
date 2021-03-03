package model

const categoryIdentifier = "CAT"

var noCategory = sarifTaxanomyDefinition{
	DefinitionID:               categoryIdentifier + "000",
	DefinitionName:             "Undefined Category",
	DefinitionShortDescription: sarifMessage{Text: "Category is not defined"},
	DefinitionFullDescription:  sarifMessage{Text: "Category is not defined"},
}

var categories = map[string]sarifTaxanomyDefinition{
	"Access control": {
		DefinitionID:   categoryIdentifier + "001",
		DefinitionName: "Access control",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Azure container services": {
		DefinitionID:   categoryIdentifier + "002",
		DefinitionName: "Azure container services",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Backup and disaster recovery": {
		DefinitionID:   categoryIdentifier + "003",
		DefinitionName: "Backup and disaster recovery",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Best practices": {
		DefinitionID:   categoryIdentifier + "004",
		DefinitionName: "Best practices",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Cloud assets management": {
		DefinitionID:   categoryIdentifier + "005",
		DefinitionName: "Cloud assets management",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Compute": {
		DefinitionID:   categoryIdentifier + "006",
		DefinitionName: "Compute",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Container": {
		DefinitionID:   categoryIdentifier + "007",
		DefinitionName: "Container",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Data security": {
		DefinitionID:   categoryIdentifier + "008",
		DefinitionName: "Data security",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Defaults": {
		DefinitionID:   categoryIdentifier + "009",
		DefinitionName: "Defaults",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"DNS Management": {
		DefinitionID:   categoryIdentifier + "010",
		DefinitionName: "DNS Management",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Encryption & Key Management": {
		DefinitionID:   categoryIdentifier + "011",
		DefinitionName: "Encryption & Key Management",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Encryption &KeyManagement": {
		DefinitionID:   categoryIdentifier + "012",
		DefinitionName: "Encryption &KeyManagement",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Encryption and Key Management": {
		DefinitionID:   categoryIdentifier + "013",
		DefinitionName: "Encryption and Key Management",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Filesystem": {
		DefinitionID:   categoryIdentifier + "014",
		DefinitionName: "Filesystem",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"High Availability": {
		DefinitionID:   categoryIdentifier + "015",
		DefinitionName: "High Availability",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Identity & Access Management": {
		DefinitionID:   categoryIdentifier + "016",
		DefinitionName: "Identity & Access Management",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Identity and Access Management": {
		DefinitionID:   categoryIdentifier + "017",
		DefinitionName: "Identity and Access Management",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Image": {
		DefinitionID:   categoryIdentifier + "018",
		DefinitionName: "Image",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Key management": {
		DefinitionID:   categoryIdentifier + "019",
		DefinitionName: "Key management",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Logging": {
		DefinitionID:   categoryIdentifier + "020",
		DefinitionName: "Logging",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Metadata": {
		DefinitionID:   categoryIdentifier + "021",
		DefinitionName: "Metadata",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Monitoring": {
		DefinitionID:   categoryIdentifier + "022",
		DefinitionName: "Monitoring",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Multi-Stage": {
		DefinitionID:   categoryIdentifier + "023",
		DefinitionName: "Multi-Stage",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Network and Security": {
		DefinitionID:   categoryIdentifier + "024",
		DefinitionName: "Network and Security",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Network Ports Security": {
		DefinitionID:   categoryIdentifier + "025",
		DefinitionName: "Network Ports Security",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Network Security": {
		DefinitionID:   categoryIdentifier + "026",
		DefinitionName: "Network Security",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Networking": {
		DefinitionID:   categoryIdentifier + "027",
		DefinitionName: "Networking",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Operational": {
		DefinitionID:   categoryIdentifier + "028",
		DefinitionName: "Operational",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Operational Efficiency": {
		DefinitionID:   categoryIdentifier + "029",
		DefinitionName: "Operational Efficiency",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Package Management": {
		DefinitionID:   categoryIdentifier + "030",
		DefinitionName: "Package Management",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Privileges": {
		DefinitionID:   categoryIdentifier + "031",
		DefinitionName: "Privileges",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Resources Limiting": {
		DefinitionID:   categoryIdentifier + "032",
		DefinitionName: "Resources Limiting",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Runtime": {
		DefinitionID:   categoryIdentifier + "033",
		DefinitionName: "Runtime",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"S3": {
		DefinitionID:   categoryIdentifier + "034",
		DefinitionName: "S3",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Secrets": {
		DefinitionID:   categoryIdentifier + "035",
		DefinitionName: "Secrets",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Storage": {
		DefinitionID:   categoryIdentifier + "036",
		DefinitionName: "Storage",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"User Management": {
		DefinitionID:   categoryIdentifier + "037",
		DefinitionName: "User Management",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Versioning": {
		DefinitionID:   categoryIdentifier + "038",
		DefinitionName: "Versioning",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
	"Vulnerability and Threat Management": {
		DefinitionID:   categoryIdentifier + "039",
		DefinitionName: "Vulnerability and Threat Management",
		DefinitionShortDescription: sarifMessage{
			Text: "Description of category",
		},
		DefinitionFullDescription: sarifMessage{
			Text: "Description of category",
		},
	},
}

package model

const categoryIdentifier = "CAT"

var noCategory = taxonomyDefinitions{
	DefinitionID:               categoryIdentifier + "000",
	DefinitionName:             "Undefined Category",
	DefinitionShortDescription: cweMessage{Text: "Category is not defined"},
	DefinitionFullDescription:  cweMessage{Text: "Category is not defined"},
}

func createSarifCategory(identifier, name, description string) taxonomyDefinitions {
	return taxonomyDefinitions{
		DefinitionID:   identifier,
		DefinitionName: name,
		DefinitionShortDescription: cweMessage{
			Text: description,
		},
		DefinitionFullDescription: cweMessage{
			Text: description,
		},
	}
}

var categories = map[string]taxonomyDefinitions{
	"Access Control": createSarifCategory(categoryIdentifier+"001", "Access Control", "Service permission and identity management"),
	"Availability":   createSarifCategory(categoryIdentifier+"002", "Availability", "Reliability and Scalability"),
	"Backup":         createSarifCategory(categoryIdentifier+"003", "Backup", "Survivability and Recovery"),
	"Best Practices": createSarifCategory(categoryIdentifier+"004", "Best Practices", "Metadata management"),
	"Build Process": createSarifCategory(
		categoryIdentifier+"005",
		"Build Process",
		"Insecure configurations when building/deploying",
	),
	"Encryption": createSarifCategory(categoryIdentifier+"006", "Encryption", "Data Security and Encryption configuration"),
	"Insecure Configurations": createSarifCategory(
		categoryIdentifier+"007",
		"Insecure Configurations",
		"Configurations which expose the application unnecessarily",
	),
	"Insecure Defaults": createSarifCategory(
		categoryIdentifier+"008",
		"Insecure Defaults",
		"Configurations that are insecure by default",
	),
	"Networking and Firewall": createSarifCategory(
		categoryIdentifier+"009",
		"Networking and Firewall",
		"Network port exposure and firewall configuration",
	),
	"Observability": createSarifCategory(categoryIdentifier+"010", "Observability", "Logging and Monitoring"),
	"Resource Management": createSarifCategory(
		categoryIdentifier+"011",
		"Resource Management",
		"Resource and privilege limit configuration",
	),
	"Secret Management": createSarifCategory(categoryIdentifier+"012", "Secret Management", "Secret and Key management"),
	"Supply-Chain":      createSarifCategory(categoryIdentifier+"013", "Supply-Chain", "Dependency version management"),
	"Structure and Semantics": createSarifCategory(
		categoryIdentifier+"014",
		"Structure and Semantics",
		"Malformed document structure or inadequate semantics",
	),
	"Bill Of Materials": createSarifCategory(categoryIdentifier+"015", "Bill Of Materials", "List of resources provisioned"),
}

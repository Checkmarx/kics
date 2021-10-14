package model

const categoryIdentifier = "CAT"

var noCategory = sarifTaxanomyDefinition{
	DefinitionID:               categoryIdentifier + "000",
	DefinitionName:             "Undefined Category",
	DefinitionShortDescription: sarifMessage{Text: "Category is not defined"},
	DefinitionFullDescription:  sarifMessage{Text: "Category is not defined"},
}

func createSarifCategory(identifier, name, description string) sarifTaxanomyDefinition {
	return sarifTaxanomyDefinition{
		DefinitionID:   identifier,
		DefinitionName: name,
		DefinitionShortDescription: sarifMessage{
			Text: description,
		},
		DefinitionFullDescription: sarifMessage{
			Text: description,
		},
	}
}

var categories = map[string]sarifTaxanomyDefinition{
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

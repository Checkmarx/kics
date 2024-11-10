package Cx

import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	[path, value] = walk(doc)

	value.enum[name]

	regex.match(`(^[A-Z][a-z0-9]+)+`, name) == false

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("enum[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Enum Name should follow CamelCase (Initial Letter is Capital)",
		"keyActualValue": "Enum Name doesn't follow CamelCase",
	}
}

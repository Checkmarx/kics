package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	parameters := value.parameters
	parameters[p].type == "secureString"
	parameters[p].defaultValue != "[newGuid()]"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("parameters.%s.defaultValue", [p]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("parameters.%s.defaultValue should not be hardcoded", [p]),
		"keyActualValue": sprintf("parameters.%s.defaultValue is hardcoded", [p]),
		"searchLine": common_lib.build_search_line(["parameters", p, "defaultValue"], []),
	}
}

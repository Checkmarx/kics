package Cx

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	parameters := value.parameters
	parameters[p].type == "secureString"
	parameters[p].defaultValue != "[newGuid()]"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("parameters.%s.defaultValue", [p]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("parameters.%s.defaultValue is not hardcoded", [p]),
		"keyActualValue": sprintf("parameters.%s.defaultValue is hardcoded", [p]),
	}
}

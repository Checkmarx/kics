package Cx

import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	variable := document.variable[variableName]
	not common_lib.valid_key(variable, "type")

	result := {
		"documentId": document.id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("variable.{{%s}}", [variableName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'type' should be defined and not null",
		"keyActualValue": "'type' is undefined or null",
	}
}

CxPolicy[result] {
	some document in input.document
	type := document.variable[variableName].type
	count(trim(type, " ")) == 0

	result := {
		"documentId": document.id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("variable.{{%s}}.type", [variableName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'type' should not be empty",
		"keyActualValue": "'type' is empty",
	}
}

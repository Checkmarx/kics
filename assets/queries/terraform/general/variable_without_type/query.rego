package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	variable := input.document[i].variable[variableName]
	not common_lib.valid_key(variable, "type")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("variable.{{%s}}", [variableName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'type' is defined and not null",
		"keyActualValue": "'type' is undefined or null",
	}
}

CxPolicy[result] {
	type := input.document[i].variable[variableName].type
	count(trim(type, " ")) == 0

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("variable.{{%s}}.type", [variableName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'type' is not empty",
		"keyActualValue": "'type' is empty",
	}
}

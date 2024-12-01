package Cx

import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	variable := document.variable[variableName]
	not common_lib.valid_key(variable, "description")

	result := {
		"documentId": document.id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("variable.{{%s}}", [variableName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'description' should be defined and not null",
		"keyActualValue": "'description' is undefined or null",
	}
}

CxPolicy[result] {
	some document in input.document
	description := document.variable[variableName].description
	count(trim(description, " ")) == 0

	result := {
		"documentId": document.id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("variable.{{%s}}.description", [variableName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'description' should not be empty",
		"keyActualValue": "'description' is empty",
	}
}

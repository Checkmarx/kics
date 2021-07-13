package Cx

CxPolicy[result] {
	variable := input.document[i].variable[variableName]
	object.get(variable, "type", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("variable.{{%s}}", [variableName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'type' is defined",
		"keyActualValue": "'type' is not defined",
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

package Cx

CxPolicy[result] {
	variable := input.document[i].variable[variableName]
	object.get(variable, "description", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("variable.{{%s}}", [variableName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'description' is defined",
		"keyActualValue": "'description' is not defined",
	}
}

CxPolicy[result] {
	description := input.document[i].variable[variableName].description
	count(trim(description, " ")) == 0

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("variable.{{%s}}.description", [variableName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'description' is not empty",
		"keyActualValue": "'description' is empty",
	}
}

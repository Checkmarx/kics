package Cx

CxPolicy[result] {
	output := input.document[i].output[outputName]
	object.get(output, "description", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("output.{{%s}}", [outputName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'description' is defined",
		"keyActualValue": "'description' is not defined",
	}
}

CxPolicy[result] {
	description := input.document[i].output[outputName].description
	count(trim(description, " ")) == 0

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("output.{{%s}}.description", [outputName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'description' is not empty",
		"keyActualValue": "'description' is empty",
	}
}

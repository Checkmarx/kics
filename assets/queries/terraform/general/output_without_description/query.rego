package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	output := input.document[i].output[outputName]
	not common_lib.valid_key(output, "description")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("output.{{%s}}", [outputName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'description' should be defined and not null",
		"keyActualValue": "'description' is undefined or null",
	}
}

CxPolicy[result] {
	description := input.document[i].output[outputName].description
	count(trim(description, " ")) == 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("output.{{%s}}.description", [outputName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'description' should not be empty",
		"keyActualValue": "'description' is empty",
	}
}

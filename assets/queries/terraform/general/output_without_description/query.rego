package Cx

import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	output := document.output[outputName]
	not common_lib.valid_key(output, "description")

	result := {
		"documentId": document.id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("output.{{%s}}", [outputName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'description' should be defined and not null",
		"keyActualValue": "'description' is undefined or null",
	}
}

CxPolicy[result] {
	some document in input.document
	description := document.output[outputName].description
	count(trim(description, " ")) == 0

	result := {
		"documentId": document.id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("output.{{%s}}.description", [outputName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'description' should not be empty",
		"keyActualValue": "'description' is empty",
	}
}

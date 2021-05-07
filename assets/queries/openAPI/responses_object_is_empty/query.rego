package Cx

import data.generic.openapi as openapi_lib

options := {null, {}}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	doc.paths[path][op].responses == options[x]

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.responses", [path, op]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.responses is not empty", [path, op]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.responses is empty", [path, op]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	doc.components.responses == options[x]

	result := {
		"documentId": doc.id,
		"searchKey": "components.responses",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "components.responses is not empty",
		"keyActualValue": "components.responsesis empty",
	}
}

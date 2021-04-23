package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	options := {null, {}}
	doc.paths[path][op].responses == options[x]

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("openapi.paths.{{%s}}.{{%s}}.responses", [path, op]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("openapi.paths.{{%s}}.{{%s}}.responses is not empty", [path, op]),
		"keyActualValue": sprintf("openapi.paths.{{%s}}.{{%s}}.responses is empty", [path, op]),
	}
}

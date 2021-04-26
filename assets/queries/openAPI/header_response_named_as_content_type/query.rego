package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	response := doc.paths[n][oper].responses[r].headers[h]

	lower(h) == "content-type"

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("openapi.paths.{{%s}}.{{%s}}.responses.{{%s}}.headers.{{%s}}", [n, oper, r, h]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("openapi.paths.{{%s}}.{{%s}}.responses.{{%s}}.headers.{{%s}} is not 'Content-Type'", [n, oper, r, h]),
		"keyActualValue": sprintf("openapi.paths.{{%s}}.{{%s}}.responses.{{%s}}.headers.{{%s}} is 'Content-Type'", [n, oper, r, h]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema := doc.components.responses[r].headers[h]

	lower(h) == "content-type"

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.responses.{{%s}}.headers.{{%s}}", [r, h]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("components.responses.{{%s}}.headers.{{%s}} is not 'Content-Type'", [r, h]),
		"keyActualValue": sprintf("components.responses.{{%s}}.headers.{{%s}} is 'Content-Type'", [r, h]),
	}
}

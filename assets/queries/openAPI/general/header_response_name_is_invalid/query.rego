package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"
	response := doc.paths[n][oper].responses[r].headers[h]

	check_ignored_header(lower(trim_space(h)))

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.headers.{{%s}}", [n, oper, r, h]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.headers should not contain '%s'", [n, oper, r, h]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.headers contains '%s'", [n, oper, r, h]),
		"overrideKey": version,
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	schema := doc.responses[r].headers[h]

	check_ignored_header(lower(trim_space(h)))

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("responses.{{%s}}.headers.{{%s}}", [r, h]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("responses.{{%s}}.headers should not contain '%s'", [r, h]),
		"keyActualValue": sprintf("responses.{{%s}}.headers contains '%s'", [r, h]),
		"overrideKey": "2.0",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	schema := doc.components.responses[r].headers[h]

	check_ignored_header(lower(trim_space(h)))

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.responses.{{%s}}.headers.{{%s}}", [r, h]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("components.responses.{{%s}}.headers should not contain '%s'", [r, h]),
		"keyActualValue": sprintf("components.responses.{{%s}}.headers contains '%s'", [r, h]),
	}
}

check_ignored_header(headerName) {
	ignoredNames := ["content-type", "accept", "authorization"]
	headerName == ignoredNames[name]
}

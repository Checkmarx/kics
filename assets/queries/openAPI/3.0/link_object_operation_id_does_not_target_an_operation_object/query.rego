package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	op := doc.components.links[l].operationId
	not check_link(doc, op)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.links.{{%s}}.operationId", [l]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("components.links.{{%s}}.operationId points to an operationId of an operation object", [l]),
		"keyActualValue": sprintf("components.links.{{%s}}.operationId does not point to an operationId of an operation object", [l]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	op := doc.components.responses[r].links[l].operationId
	not check_link(doc, op)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.responses.{{%s}}.links.{{%s}}.operationId", [r, l]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("components.responses.%s.links.%s.operationId points to an operationId of an operation object", [r, l]),
		"keyActualValue": sprintf("components.responses.%s.links.%s.operationId does not point to an operationId of an operation object", [r, l]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	op := doc.paths[path][operation].responses[r].links[l].operationId
	openapi_lib.content_allowed(operation, r)
	not check_link(doc, op)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.links.{{%s}}.operationId", [path, operation, r, l]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths%s.%s.responses.%s.links.%s.operationId points to an operationId of an operation object", [path, operation, r, l]),
		"keyActualValue": sprintf("paths.%s.%s.responses.%s.links.%s.operationId does not point to an operationId of an operation object", [path, operation, r, l]),
	}
}

check_link(doc, op) {
	doc.paths[path][operation].operationId == op
}

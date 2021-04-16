package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	not check_link(doc, doc.components.links.address.operationId)

	result := {
		"documentId": doc.id,
		"searchKey": "components.links.address.operationId",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "components.links.address.operationId points to an operationId of an operation object",
		"keyActualValue": "components.links.address.operationId does not point to an operationId of an operation object",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	op := doc.components.responses[r].links.address.operationId
	not check_link(doc, op)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.responses.{{%s}}.links.address.operationId", [r]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("components.responses.%s.links.address.operationId points to an operationId of an operation object", [r]),
		"keyActualValue": sprintf("components.responses.%s.links.address.operationId does not point to an operationId of an operation object", [r]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	op := doc.paths[path][operation].responses[r].links.address.operationId
	not check_link(doc, op)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.links", [path, operation, r]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths%s.%s.responses.%s.links.address.operationId points to an operationId of an operation object", [path, operation, r]),
		"keyActualValue": sprintf("paths.%s.%s.responses.%s.links.address.operationId does not point to an operationId of an operation object", [path, operation, r]),
	}
}

check_link(doc, op) {
	doc.paths[path][operation].operationId == op
}

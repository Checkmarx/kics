package Cx

import data.generic.openapi as openapi_lib
import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	link := doc.components.links[l]
	check_link(link)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.links.{{%s}}", [l]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("components.links.%s has both 'operationId' and 'operationRef' defined", [l]),
		"keyActualValue": sprintf("components.links.%s does not have both 'operationId' and 'operationRef' defined", [l]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	link := doc.components.responses[r].links[l]
	check_link(link)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.responses.{{%s}}.links.{{%s}}", [r, l]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("components.responses.%s.links.%s has both 'operationId' and 'operationRef' defined", [r, l]),
		"keyActualValue": sprintf("components.responses.%s.links.%s does not have both 'operationId' and 'operationRef' defined", [r, l]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	link := doc.paths[path][operation].responses[r].links[l]
	openapi_lib.content_allowed(operation, r)
	check_link(link)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.links.{{%s}}", [path, operation, r, l]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths%s.%s.responses.%s.links.%s has both 'operationId' and 'operationRef' defined", [path, operation, r, l]),
		"keyActualValue": sprintf("paths.%s.%s.responses.%s.links.%s does not have both 'operationId' and 'operationRef' defined", [path, operation, r, l]),
	}
}

check_link(link) {
	common_lib.valid_key(link, "operationId")
	common_lib.valid_key(link, "operationRef")
}

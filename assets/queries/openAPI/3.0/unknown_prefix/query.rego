package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema_properties := doc.paths[path][operation].responses[r].content[c]
	openapi_lib.content_allowed(operation, r)
	not match(c)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content.{{%s}}", [path, operation, r, c]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content.{{%s}} is a known prefix", [path, operation, r, c]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content.{{%s}} is an unknown prefix", [path, operation, r, c]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema_properties := doc.paths[path][operation].requestBody.content[c]
	not match(c)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.requestBody.content.{{%s}}", [path, operation, c]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.requestBody.content.{{%s}} is a known prefix", [path, operation, c]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.requestBody.content.{{%s}} is an unknown prefix", [path, operation, c]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema_properties := doc.components.requestBodies[r].content[c]
	not match(c)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.requestBodies.{{%s}}.content.{{%s}}", [r, c]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("components.requestBodies.{{%s}}.content.{{%s}} is a known prefix", [r, c]),
		"keyActualValue": sprintf("components.requestBodies.{{%s}}.content.{{%s}} is an unknown prefix", [r, c]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema_properties := doc.components.responses[r].content[c]
	not match(c)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.responses.{{%s}}.content.{{%s}}", [r, c]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("components.responses.{{%s}}.content.{{%s}} is a known prefix", [r, c]),
		"keyActualValue": sprintf("components.responses.{{%s}}.content.{{%s}} is an unknown prefix", [r, c]),
	}
}

match(content) {
	known_prefixs := {"application", "audio", "font", "example", "image", "message", "model", "multipart", "text", "video"}
	count({x | prefix := known_prefixs[x]; startswith(content, prefix)}) > 0
}

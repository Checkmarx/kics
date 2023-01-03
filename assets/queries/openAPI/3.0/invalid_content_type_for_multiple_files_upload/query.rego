package Cx

import data.generic.openapi as openapi_lib

options := {"file", "filename"}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	property := doc.paths[path][operation].requestBody.content[c].schema.properties[p]
	p == options[x]

	property.type == "array"
	property.items.format == "binary"
	c != "multipart/form-data"

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.requestBody.content.{{%s}}", [path, operation, c]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.requestBody.content.{{%s}} should be set to 'multipart/form-data'", [path, operation, c]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.requestBody.content.{{%s}} is not set to 'multipart/form-data'", [path, operation, c]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	property := doc.components.requestBodies[r].content[c].schema.properties[p]
	p == options[x]

	property.type == "array"
	property.items.format == "binary"
	c != "multipart/form-data"

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.requestBodies.{{%s}}.content.{{%s}}", [r, c]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("components.requestBodies.{{%s}}.content.{{%s}} should be set to 'multipart/form-data'", [r, c]),
		"keyActualValue": sprintf("components.requestBodies.{{%s}}.content.{{%s}} is not set to 'multipart/form-data'", [r, c]),
	}
}

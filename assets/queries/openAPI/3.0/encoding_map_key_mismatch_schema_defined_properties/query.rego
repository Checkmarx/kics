package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	schema_properties := doc.paths[path][operation].responses[r].content[c].schema.properties
	openapi_lib.content_allowed(operation, r)
	encoding_key := doc.paths[path][operation].responses[r].content[c].encoding[e]

	not match(schema_properties, e)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content.{{%s}}.encoding.{{%s}}", [path, operation, r, c, e]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content.{{%s}}.encoding.{{%s}} should be set in schema defined properties", [path, operation, r, c, e]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content.{{%s}}.encoding.{{%s}} is not set in schema defined properties", [path, operation, r, c, e]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	schema_properties := doc.paths[path][operation].requestBody.content[c].schema.properties
	encoding_key := doc.paths[path][operation].requestBody.content[c].encoding[e]

	not match(schema_properties, e)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.requestBody.content.{{%s}}.encoding.{{%s}}", [path, operation, c, e]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.requestBody.content.{{%s}}.encoding.{{%s}} should be set in schema defined properties", [path, operation, c, e]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.requestBody.content.{{%s}}.encoding.{{%s}} is not set in schema defined properties", [path, operation, c, e]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	schema_properties := doc.components.requestBodies[r].content[c].schema.properties
	encoding_key := doc.components.requestBodies[r].content[c].encoding[e]

	not match(schema_properties, e)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.requestBodies.{{%s}}.content.{{%s}}.encoding.{{%s}}", [r, c, e]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("components.requestBodies.{{%s}}.content.{{%s}}.encoding.{{%s}} should be set in schema defined properties", [r, c, e]),
		"keyActualValue": sprintf("components.requestBodies.{{%s}}.content.{{%s}}.encoding.{{%s}} is not set in schema defined properties", [r, c, e]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	schema_properties := doc.components.responses[r].content[c].schema.properties
	encoding_key := doc.components.responses[r].content[c].encoding[e]

	not match(schema_properties, e)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.responses.{{%s}}.content.{{%s}}.encoding.{{%s}}", [r, c, e]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("components.responses.{{%s}}.content.{{%s}}.encoding.{{%s}} should be set in schema defined properties", [r, c, e]),
		"keyActualValue": sprintf("components.responses.{{%s}}.content.{{%s}}.encoding.{{%s}} is not set in schema defined properties", [r, c, e]),
	}
}

match(properties, encoding_key) {
	property := properties[x]
	x == encoding_key
}

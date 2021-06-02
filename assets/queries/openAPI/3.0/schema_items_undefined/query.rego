package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema := doc.paths[path][operation].responses[r].content[c].schema
	openapi_lib.content_allowed(operation, r)

	schema.type == "array"
	not schema.items

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content.{{%s}}.schema", [path, operation, r, c]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content.{{%s}}.schema.items is set", [path, operation, r, c]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content.{{%s}}.schema.items is undefined", [path, operation, r, c]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema := doc.paths[path].parameters[parameter].schema

	schema.type == "array"
	not schema.items

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.parameters.{{%s}}.schema", [path, parameter]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("paths.{{%s}}.parameters.{{%s}}.schema.items is set", [path, parameter]),
		"keyActualValue": sprintf("paths.{{%s}}.parameters.{{%s}}.schema.items is undefined", [path, parameter]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema := doc.paths[path][operation].parameters[parameter].schema

	schema.type == "array"
	not schema.items

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.parameters.{{%s}}.schema", [path, operation, parameter]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.parameters.{{%s}}.schema.items is set", [path, operation, parameter]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.parameters.{{%s}}.schema.items is undefined", [path, operation, parameter]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema := doc.paths[path][operation].requestBody.content[c].schema

	schema.type == "array"
	not schema.items

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.requestBody.content.{{%s}}.schema", [path, operation, c]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.requestBody.content.{{%s}}.schema.items is set", [path, operation, c]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.requestBody.content.{{%s}}.schema.items is undefined", [path, operation, c]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema := doc.components.requestBodies[r].content[c].schema

	schema.type == "array"
	not schema.items

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.requestBodies.{{%s}}.content.{{%s}}.schema", [r, c]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("components.requestBodies.{{%s}}.content.{{%s}}.schema.items is set", [r, c]),
		"keyActualValue": sprintf("components.requestBodies.{{%s}}.content.{{%s}}.schema.items is undefined", [r, c]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema := doc.components.parameters[parameter].schema

	schema.type == "array"
	not schema.items

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.parameters.{{%s}}.schema", [parameter]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("components.parameters.{{%s}}.schema.items is set", [parameter]),
		"keyActualValue": sprintf("components.parameters.{{%s}}.schema.items is undefined", [parameter]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema := doc.components.responses[r].content[c].schema

	schema.type == "array"
	not schema.items

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.responses.{{%s}}.content.{{%s}}.schema", [r, c]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("components.responses.{{%s}}.content.{{%s}}.schema.items is set", [r, c]),
		"keyActualValue": sprintf("components.responses.{{%s}}.content.{{%s}}.schema.items is undefined", [r, c]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema := doc.components.schemas[s]

	schema.type == "array"
	not schema.items

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.schemas.{{%s}}", [s]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("components.schemas.{{%s}}.items is set", [s]),
		"keyActualValue": sprintf("components.schemas.{{%s}}.items is undefined", [s]),
	}
}

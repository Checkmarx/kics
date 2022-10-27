package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	schema := doc.paths[path][operation].responses[r].content[c].schema
	openapi_lib.content_allowed(operation, r)

	both(schema)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content.{{%s}}.schema", [path, operation, r, c]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content.{{%s}}.schema should not have both 'writeOnly' and 'readOnly' set to true", [path, operation, r, c]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content.{{%s}}.schema has both 'writeOnly' and 'readOnly' set to true", [path, operation, r, c]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	schema := doc.paths[path].parameters[parameter].schema

	both(schema)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.parameters.{{%s}}.schema", [path, parameter]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.parameters.{{%s}}.schema should not have both 'writeOnly' and 'readOnly' set to true", [path, parameter]),
		"keyActualValue": sprintf("paths.{{%s}}.parameters.{{%s}}.schema has both 'writeOnly' and 'readOnly' set to true", [path, parameter]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	schema := doc.paths[path][operation].parameters[parameter].schema

	both(schema)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.parameters.{{%s}}.schema", [path, operation, parameter]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.parameters.{{%s}}.schema should not have both 'writeOnly' and 'readOnly' set to true", [path, operation, parameter]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.parameters.{{%s}}.schema has both 'writeOnly' and 'readOnly' set to true", [path, operation, parameter]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	schema := doc.paths[path][operation].requestBody.content[c].schema

	both(schema)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.requestBody.content.{{%s}}.schema", [path, operation, c]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.requestBody.content.{{%s}}.schema should not have both 'writeOnly' and 'readOnly' set to true", [path, operation, c]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.requestBody.content.{{%s}}.schema has both 'writeOnly' and 'readOnly' set to true", [path, operation, c]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	schema := doc.components.requestBodies[r].content[c].schema

	both(schema)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.requestBodies.{{%s}}.content.{{%s}}.schema", [r, c]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("components.requestBodies.{{%s}}.content.{{%s}}.schema should not have both 'writeOnly' and 'readOnly' set to true", [r, c]),
		"keyActualValue": sprintf("components.requestBodies.{{%s}}.content.{{%s}}.schema has both 'writeOnly' and 'readOnly' set to true", [r, c]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	schema := doc.components.parameters[parameter].schema

	both(schema)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.parameters.{{%s}}.schema", [parameter]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("components.parameters.{{%s}}.schema should not have both 'writeOnly' and 'readOnly' set to true", [parameter]),
		"keyActualValue": sprintf("components.parameters.{{%s}}.schema has both 'writeOnly' and 'readOnly' set to true", [parameter]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	schema := doc.components.responses[r].content[c].schema

	both(schema)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.responses.{{%s}}.content.{{%s}}.schema", [r, c]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("components.responses.{{%s}}.content.{{%s}}.schema should not have both 'writeOnly' and 'readOnly' set to true", [r, c]),
		"keyActualValue": sprintf("components.responses.{{%s}}.content.{{%s}}.schema has both 'writeOnly' and 'readOnly' set to true", [r, c]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	schema := doc.components.schemas[s]

	both(schema)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.schemas.{{%s}}", [s]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("components.schemas.{{%s}} should not have both 'writeOnly' and 'readOnly' set to true", [s]),
		"keyActualValue": sprintf("components.schemas.{{%s}} has both 'writeOnly' and 'readOnly' set to true", [s]),
	}
}

both(schema) {
	options := {true, "true"}
	schema.properties.id.readOnly == options[x]
	schema.properties.id.writeOnly == options[x]
}

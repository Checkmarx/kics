package Cx

import data.generic.openapi as openapi_lib

options := {{}, null}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema := doc.paths[path][operation].responses[r].content[c].schema
	openapi_lib.content_allowed(operation, r)
	schema == options[x]

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content.{{%s}}.schema", [path, operation, r, c]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content.{{%s}}.schema is not empty", [path, operation, r, c]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content.{{%s}}.schema is empty", [path, operation, r, c]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema := doc.paths[path].parameters[parameter].schema
	schema == options[x]

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.parameters.{{%s}}.schema", [path, parameter]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.parameters.{{%s}}.schema is not empty", [path, parameter]),
		"keyActualValue": sprintf("paths.{{%s}}.parameters.{{%s}}.schema is empty", [path, parameter]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema := doc.paths[path][operation].parameters[parameter].schema
	schema == options[x]

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.parameters.{{%s}}.schema", [path, operation, parameter]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.parameters.{{%s}}.schema is not empty", [path, operation, parameter]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.parameters.{{%s}}.schema is empty", [path, operation, parameter]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema := doc.paths[path][operation].requestBody.content[c].schema
	schema == options[x]

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.requestBody.content.{{%s}}.schema", [path, operation, c]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.requestBody.content.{{%s}}.schema is not empty", [path, operation, c]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.requestBody.content.{{%s}}.schema is empty", [path, operation, c]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema := doc.components.requestBodies[r].content[c].schema
	schema == options[x]

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.requestBodies.{{%s}}.content.{{%s}}.schema", [r, c]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("components.requestBodies.{{%s}}.content.{{%s}}.schema is not empty", [r, c]),
		"keyActualValue": sprintf("components.requestBodies.{{%s}}.content.{{%s}}.schema is empty", [r, c]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema := doc.components.parameters[parameter].schema
	schema == options[x]

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.parameters.{{%s}}.schema", [parameter]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("components.parameters.{{%s}}.schema is not empty", [parameter]),
		"keyActualValue": sprintf("components.parameters.{{%s}}.schema is empty", [parameter]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema := doc.components.responses[r].content[c].schema
	schema == options[x]

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.responses.{{%s}}.content.{{%s}}.schema", [r, c]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("components.responses.{{%s}}.content.{{%s}}.schema is not empty", [r, c]),
		"keyActualValue": sprintf("components.responses.{{%s}}.content.{{%s}}.schema is empty", [r, c]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema := doc.components.schemas[s]
	schema == options[x]

	result := {
		"documentId": doc.id,
		"searchKey": "components.schemas",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "components.schemas is not empty",
		"keyActualValue": "components.schemas is empty",
	}
}

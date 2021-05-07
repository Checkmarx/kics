package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	url := doc.paths[path][operation].responses[r].content[c].schema.externalDocs.url
	openapi_lib.content_allowed(operation, r)
	not openapi_lib.is_valid_url(url)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content.{{%s}}.schema.externalDocs.url", [path, operation, r, c]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content.{{%s}}.schema.externalDocs.url has a valid URL", [path, operation, r, c]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content.{{%s}}.schema.externalDocs.url has a invalid URL", [path, operation, r, c]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	url := doc.paths[path].parameters[parameter].schema.externalDocs.url
	not openapi_lib.is_valid_url(url)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.parameters.{{%s}}.schema.externalDocs.url", [path, parameter]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.parameters.{{%s}}.schema.externalDocs.url has a valid URL", [path, parameter]),
		"keyActualValue": sprintf("paths.{{%s}}.parameters.{{%s}}.schema.externalDocs.url has a invalid URL", [path, parameter]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	url := doc.paths[path][operation].parameters[parameter].schema.externalDocs.url
	not openapi_lib.is_valid_url(url)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.parameters.{{%s}}.schema.externalDocs.url", [path, operation, parameter]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.parameters.{{%s}}.schema.externalDocs.url has a valid URL", [path, operation, parameter]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.parameters.{{%s}}.schema.externalDocs.url has a invalid URL", [path, operation, parameter]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	url := doc.paths[path][operation].requestBody.content[c].schema.externalDocs.url
	not openapi_lib.is_valid_url(url)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.requestBody.content.{{%s}}.schema.externalDocs.url", [path, operation, c]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.requestBody.content.{{%s}}.schema.externalDocs.url has a valid URL", [path, operation, c]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.requestBody.content.{{%s}}.schema.externalDocs.url has a invalid URL", [path, operation, c]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	url := doc.components.requestBodies[r].content[c].schema.externalDocs.url
	not openapi_lib.is_valid_url(url)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.requestBodies.{{%s}}.content.{{%s}}.schema.externalDocs.url", [r, c]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("components.requestBodies.{{%s}}.content.{{%s}}.schema.externalDocs.url has a valid URL", [r, c]),
		"keyActualValue": sprintf("components.requestBodies.{{%s}}.content.{{%s}}.schema.externalDocs.url has a invalid URL", [r, c]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	url := doc.components.parameters[parameter].schema.externalDocs.url
	not openapi_lib.is_valid_url(url)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.parameters.{{%s}}.schema.externalDocs.url", [parameter]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("components.parameters.{{%s}}.schema.externalDocs.url has a valid URL", [parameter]),
		"keyActualValue": sprintf("components.parameters.{{%s}}.schema.externalDocs.url has a invalid URL", [parameter]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	url := doc.components.responses[r].content[c].schema.externalDocs.url
	not openapi_lib.is_valid_url(url)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.responses.{{%s}}.content.{{%s}}.schema.externalDocs.url", [r, c]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("components.responses.{{%s}}.content.{{%s}}.schema.externalDocs.url has a valid URL", [r, c]),
		"keyActualValue": sprintf("components.responses.{{%s}}.content.{{%s}}.schema.externalDocs.url has a invalid URL", [r, c]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	url := doc.components.schemas[s].externalDocs.url
	not openapi_lib.is_valid_url(url)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.schemas.{{%s}}.externalDocs.url", [s]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("components.schemas.{{%s}}.externalDocs.url has a valid URL", [s]),
		"keyActualValue": sprintf("components.schemas.{{%s}}.externalDocs.url has a invalid URL", [s]),
	}
}

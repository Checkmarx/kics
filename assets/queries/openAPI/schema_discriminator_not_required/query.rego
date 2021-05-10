package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema := doc.paths[path][operation].responses[r].content[c].schema
	openapi_lib.content_allowed(operation, r)
	discriminator := schema.discriminator.propertyName
	not required(schema, discriminator)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content.{{%s}}.schema.discriminator.propertyName", [path, operation, r, c]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content.{{%s}}.schema.discriminator.propertyName is a required property", [path, operation, r, c]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content.{{%s}}.schema.discriminator.propertyName is not a required property", [path, operation, r, c]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema := doc.paths[path].parameters[parameter].schema
	discriminator := schema.discriminator.propertyName
	not required(schema, discriminator)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.parameters.{{%s}}.schema.discriminator.propertyName", [path, parameter]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.parameters.{{%s}}.schema.discriminator.propertyName is a required property", [path, parameter]),
		"keyActualValue": sprintf("paths.{{%s}}.parameters.{{%s}}.schema.discriminator.propertyName is not a required property", [path, parameter]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema := doc.paths[path][operation].parameters[parameter].schema
	discriminator := schema.discriminator.propertyName
	not required(schema, discriminator)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.parameters.{{%s}}.schema.discriminator.propertyName", [path, operation, parameter]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.parameters.{{%s}}.schema.discriminator.propertyName is a required property", [path, operation, parameter]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.parameters.{{%s}}.schema.discriminator.propertyName is not a required property", [path, operation, parameter]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema := doc.paths[path][operation].requestBody.content[c].schema
	discriminator := schema.discriminator.propertyName
	not required(schema, discriminator)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.requestBody.content.{{%s}}.schema.discriminator.propertyName", [path, operation, c]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.requestBody.content.{{%s}}.schema.discriminator.propertyName is a required property", [path, operation, c]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.requestBody.content.{{%s}}.schema.discriminator.propertyName is not a required property", [path, operation, c]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema := doc.components.requestBodies[r].content[c].schema
	discriminator := schema.discriminator.propertyName
	not required(schema, discriminator)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.requestBodies.{{%s}}.content.{{%s}}.schema.discriminator.propertyName", [r, c]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("components.requestBodies.{{%s}}.content.{{%s}}.schema.discriminator.propertyName is a required property", [r, c]),
		"keyActualValue": sprintf("components.requestBodies.{{%s}}.content.{{%s}}.schema.discriminator.propertyName is not a required property", [r, c]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema := doc.components.parameters[parameter].schema
	discriminator := schema.discriminator.propertyName
	not required(schema, discriminator)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.parameters.{{%s}}.schema.discriminator.propertyName", [parameter]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("components.parameters.{{%s}}.schema.discriminator.propertyName is a required property", [parameter]),
		"keyActualValue": sprintf("components.parameters.{{%s}}.schema.discriminator.propertyName is not a required property", [parameter]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema := doc.components.responses[r].content[c].schema
	discriminator := schema.discriminator.propertyName
	not required(schema, discriminator)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.responses.{{%s}}.content.{{%s}}.schema.discriminator.propertyName", [r, c]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("components.responses.{{%s}}.content.{{%s}}.schema.discriminator.propertyName is a required property", [r, c]),
		"keyActualValue": sprintf("components.responses.{{%s}}.content.{{%s}}.schema.discriminator.propertyName is not a required property", [r, c]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema := doc.components.schemas[s]
	discriminator := schema.discriminator.propertyName
	not required(schema, discriminator)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.schemas.{{%s}}.discriminator.propertyName", [s]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("components.schemas.{{%s}}.discriminator.propertyName is a required property", [s]),
		"keyActualValue": sprintf("components.schemas.{{%s}}.discriminator.propertyName is not a required property", [s]),
	}
}

required(schema, discriminator) {
	schema.required[_] == discriminator
}

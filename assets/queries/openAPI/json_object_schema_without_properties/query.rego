package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema_ref := doc.paths[path][operation].responses[r].content[c].schema["$ref"]
	openapi_lib.content_allowed(operation, r)
	openapi_lib.undefined_field_in_json_object(doc, schema_ref, "properties")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content.{{%s}}.schema.$ref", [path, operation, r, c]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Schema of the JSON object has 'properties' defined",
		"keyActualValue": "Schema of the JSON object does not have 'properties' defined",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema_ref := doc.paths[path].parameters[parameter].schema["$ref"]
	openapi_lib.undefined_field_in_json_object(doc, schema_ref, "properties")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.parameters.{{%s}}.schema.$ref", [path, parameter]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Schema of the JSON object has 'properties' defined",
		"keyActualValue": "Schema of the JSON object does not have 'properties' defined",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema_ref := doc.paths[path][operation].parameters[parameter].schema["$ref"]
	openapi_lib.undefined_field_in_json_object(doc, schema_ref, "properties")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.parameters.{{%s}}.schema.$ref", [path, operation, parameter]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Schema of the JSON object has 'properties' defined",
		"keyActualValue": "Schema of the JSON object does not have 'properties' defined",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema_ref := doc.paths[path][operation].requestBody.content[c].schema["$ref"]
	openapi_lib.undefined_field_in_json_object(doc, schema_ref, "properties")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.requestBody.content.{{%s}}.schema.$ref", [path, operation, c]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Schema of the JSON object has 'properties' defined",
		"keyActualValue": "Schema of the JSON object does not have 'properties' defined",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema_ref := doc.components.requestBodies[r].content[c].schema["$ref"]
	openapi_lib.undefined_field_in_json_object(doc, schema_ref, "properties")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.requestBodies.{{%s}}.content.{{%s}}.schema.$ref", [r, c]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Schema of the JSON object has 'properties' defined",
		"keyActualValue": "Schema of the JSON object does not have 'properties' defined",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema_ref := doc.components.parameters[parameter].schema["$ref"]
	openapi_lib.undefined_field_in_json_object(doc, schema_ref, "properties")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.parameters.{{%s}}.schema.$ref", [parameter]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Schema of the JSON object has 'properties' defined",
		"keyActualValue": "Schema of the JSON object does not have 'properties' defined",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema_ref := doc.components.responses[r].content[c].schema["$ref"]
	openapi_lib.undefined_field_in_json_object(doc, schema_ref, "properties")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.responses.{{%s}}.content.{{%s}}.schema.$ref", [r, c]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Schema of the JSON object has 'properties' defined",
		"keyActualValue": "Schema of the JSON object does not have 'properties' defined",
	}
}

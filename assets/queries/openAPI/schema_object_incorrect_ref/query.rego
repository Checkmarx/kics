package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema_ref := doc.paths[path][operation].responses[r].content[c].schema["$ref"]
	openapi_lib.content_allowed(operation, r)
	openapi_lib.incorrect_ref(schema_ref, "schema")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content.{{%s}}.schema.$ref={{%s}}", [path, operation, r, c, schema_ref]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Schema reference points to '#components/schemas'",
		"keyActualValue": "Schema reference does not point to '#components/schemas'",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema_ref := doc.paths[path].parameters[parameter].schema["$ref"]
	openapi_lib.incorrect_ref(schema_ref, "schema")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.parameters.{{%s}}.schema.$ref={{%s}}", [path, parameter, schema_ref]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Schema reference points to '#components/schemas'",
		"keyActualValue": "Schema reference does not point to '#components/schemas'",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema_ref := doc.paths[path][operation].parameters[parameter].schema["$ref"]
	openapi_lib.incorrect_ref(schema_ref, "schema")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.parameters.{{%s}}.schema.$ref={{%s}}", [path, operation, parameter, schema_ref]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Schema reference points to '#components/schemas'",
		"keyActualValue": "Schema reference does not point to '#components/schemas'",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema_ref := doc.paths[path][operation].requestBody.content[c].schema["$ref"]
	openapi_lib.incorrect_ref(schema_ref, "schema")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.requestBody.content.{{%s}}.schema.$ref={{%s}}", [path, operation, c, schema_ref]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Schema reference points to '#components/schemas'",
		"keyActualValue": "Schema reference does not point to '#components/schemas'",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema_ref := doc.components.requestBodies[r].content[c].schema["$ref"]
	openapi_lib.incorrect_ref(schema_ref, "schema")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.requestBodies.{{%s}}.content.{{%s}}.schema.$ref={{%s}}", [r, c, schema_ref]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Schema reference points to '#components/schemas'",
		"keyActualValue": "Schema reference does not point to '#components/schemas'",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema_ref := doc.components.parameters[parameter].schema["$ref"]
	openapi_lib.incorrect_ref(schema_ref, "schema")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.parameters.{{%s}}.schema.$ref={{%s}}", [parameter, schema_ref]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Schema reference points to '#components/schemas'",
		"keyActualValue": "Schema reference does not point to '#components/schemas'",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema_ref := doc.components.responses[r].content[c].schema["$ref"]
	openapi_lib.incorrect_ref(schema_ref, "schema")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.responses.{{%s}}.content.{{%s}}.schema.$ref={{%s}}", [r, c, schema_ref]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Schema reference points to '#components/schemas'",
		"keyActualValue": "Schema reference does not point to '#components/schemas'",
	}
}

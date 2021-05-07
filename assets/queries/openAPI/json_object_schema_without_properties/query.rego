package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema_ref := doc.paths[path][operation].responses[r].content[c].schema["$ref"]
	undefined_properties(doc, schema_ref)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content.{{%s}}.schema.$ref", [path, operation, r, c]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Schema of the JSON object has properties defined and 'additionalProperties' set to false",
		"keyActualValue": "Schema of the JSON object does not have properties defined and/or 'additionalProperties' set to false",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema_ref := doc.paths[path].parameters[parameter].schema["$ref"]
	undefined_properties(doc, schema_ref)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.parameters.{{%s}}.schema.$ref", [path, parameter]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Schema of the JSON object has properties defined and 'additionalProperties' set to false",
		"keyActualValue": "Schema of the JSON object does not have properties defined and/or 'additionalProperties' set to false",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema_ref := doc.paths[path][operation].parameters[parameter].schema["$ref"]
	undefined_properties(doc, schema_ref)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.parameters.{{%s}}.schema.$ref", [path, operation, parameter]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Schema of the JSON object has properties defined and 'additionalProperties' set to false",
		"keyActualValue": "Schema of the JSON object does not have properties defined and/or 'additionalProperties' set to false",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema_ref := doc.paths[path][operation].requestBody.content[c].schema["$ref"]
	undefined_properties(doc, schema_ref)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.requestBody.content.{{%s}}.schema.$ref", [path, operation, c]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Schema of the JSON object has properties defined and 'additionalProperties' set to false",
		"keyActualValue": "Schema of the JSON object does not have properties defined and/or 'additionalProperties' set to false",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema_ref := doc.components.requestBodies[r].content[c].schema["$ref"]
	undefined_properties(doc, schema_ref)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.requestBodies.{{%s}}.content.{{%s}}.schema.$ref", [r, c]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Schema of the JSON object has properties defined and 'additionalProperties' set to false",
		"keyActualValue": "Schema of the JSON object does not have properties defined and/or 'additionalProperties' set to false",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema_ref := doc.components.parameters[parameter].schema["$ref"]
	undefined_properties(doc, schema_ref)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.parameters.{{%s}}.schema.$ref", [parameter]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Schema of the JSON object has properties defined and 'additionalProperties' set to false",
		"keyActualValue": "Schema of the JSON object does not have properties defined and/or 'additionalProperties' set to false",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema_ref := doc.components.responses[r].content[c].schema["$ref"]
	undefined_properties(doc, schema_ref)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.responses.{{%s}}.content.{{%s}}.schema.$ref", [r, c]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Schema of the JSON object has properties defined and 'additionalProperties' set to false",
		"keyActualValue": "Schema of the JSON object does not have properties defined and/or 'additionalProperties' set to false",
	}
}

correct_definition(component_schema) {
	object.get(component_schema, "properties", "undefined") != "undefined"
	component_schema.additionalProperties == false
}

check_content(doc, s) {
	component_schema := doc.components.schemas[sc]
	sc == s
	not correct_definition(component_schema)
}

undefined_properties(doc, schema_ref) {
	r := split(schema_ref, "/")
	count(r) == 4
	s := r[3]
	check_content(doc, s)
}

package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema := doc.paths[path][operation].responses[r].content[c].schema
	openapi_lib.content_allowed(operation, r)
	undefined_properties(doc, schema)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content.{{%s}}.schema", [path, operation, r, c]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "String schema has 'pattern' defined",
		"keyActualValue": "String schema does not have 'pattern' defined",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema := doc.paths[path].parameters[parameter].schema
	undefined_properties(doc, schema)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.parameters.{{%s}}.schema", [path, parameter]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "String schema has 'pattern' defined",
		"keyActualValue": "String schema does not have 'pattern' defined",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema := doc.paths[path][operation].parameters[parameter].schema
	undefined_properties(doc, schema)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.parameters.{{%s}}.schema", [path, operation, parameter]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "String schema has 'pattern' defined",
		"keyActualValue": "String schema does not have 'pattern' defined",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema := doc.paths[path][operation].requestBody.content[c].schema
	undefined_properties(doc, schema)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.requestBody.content.{{%s}}.schema", [path, operation, c]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "String schema has 'pattern' defined",
		"keyActualValue": "String schema does not have 'pattern' defined",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema := doc.components.requestBodies[r].content[c].schema
	undefined_properties(doc, schema)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.requestBodies.{{%s}}.content.{{%s}}.schema", [r, c]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "String schema has 'pattern' defined",
		"keyActualValue": "String schema does not have 'pattern' defined",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema := doc.components.parameters[parameter].schema
	undefined_properties(doc, schema)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.parameters.{{%s}}.schema", [parameter]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "String schema has 'pattern' defined",
		"keyActualValue": "String schema does not have 'pattern' defined",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema := doc.components.responses[r].content[c].schema
	openapi_lib.content_allowed("", r)
	undefined_properties(doc, schema)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.responses.{{%s}}.content.{{%s}}.schema", [r, c]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "String schema has 'pattern' defined",
		"keyActualValue": "String schema does not have 'pattern' defined",
	}
}

max_length_undefined(schema) {
	schema.properties[p].type == "string"
	object.get(schema.properties[p], "pattern", "undefined") == "undefined"
}

is_ref(schema) {
	count(schema) == 1
	object.get(schema, "$ref", "undefined") != "undefined"
}

check_content(doc, s) {
	component_schema := doc.components.schemas[sc]
	sc == s
	component_schema.properties[p].type == "string"
	max_length_undefined(component_schema)
}

undefined_properties(doc, schema) {
	is_ref(schema)
	r := split(schema["$ref"], "/")
	count(r) == 4
	s := r[3]
	check_content(doc, s)
}

undefined_properties(doc, schema) {
	not is_ref(schema)
	max_length_undefined(schema)
}

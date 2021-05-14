package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	[path, value] := walk(doc)
	schema = openapi_lib.get_schema(value)
	info := openapi_lib.is_operation(path)
	openapi_lib.content_allowed(info.operation, info.code)
	has_broad_schema(schema.content, doc)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.%s", [openapi_lib.concat_path(path), schema.kind]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "String schema has 'pattern' restricted",
		"keyActualValue": "String schema does not have 'pattern' restricted",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	[path, value] := walk(doc)
	schema = openapi_lib.get_schema(value)
	openapi_lib.is_operation(path) == {}
	has_broad_schema(schema.content, doc)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.%s", [openapi_lib.concat_path(path), schema.kind]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "String schema has 'pattern' restricted",
		"keyActualValue": "String schema does not have 'pattern' restricted",
	}
}

broad_schema(schema) {
	schema.properties[p].type == "string"
	startswith(schema.properties[p].pattern, "^") == false
}

has_broad_schema(schema, doc) {
	not openapi_lib.is_ref(schema)
	broad_schema(schema)
}

has_broad_schema(schema, doc) {
	openapi_lib.is_ref(schema)
	r := split(schema["$ref"], "/")
	count(r) == 4
	s := r[3]
	component_schema := doc.components.schemas[sc]
	sc == s
	broad_schema(component_schema)
}

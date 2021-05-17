package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	[path, value] := walk(doc)
	schema_kind = openapi_lib.get_schema(value)
	info := openapi_lib.is_operation(path)
	openapi_lib.content_allowed(info.operation, info.code)
	has_broad_schema(value, schema_kind, doc)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.%s", [openapi_lib.concat_path(path), schema_kind]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "String schema has 'pattern' restricted",
		"keyActualValue": "String schema does not have 'pattern' restricted",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	[path, value] := walk(doc)
	schema_kind = openapi_lib.get_schema(value)
	openapi_lib.is_operation(path) == {}
	has_broad_schema(value, schema_kind, doc)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.%s", [openapi_lib.concat_path(path), schema_kind]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "String schema has 'pattern' restricted",
		"keyActualValue": "String schema does not have 'pattern' restricted",
	}
}

broad_schema(schema) {
	schema.properties[p].type == "string"
	startswith(schema.properties[p].pattern, "^") == false
}

has_broad_schema(value, schema_kind, doc) {
	schema_kind == "schema"
	sc := value[schema_kind]
	not openapi_lib.is_ref(sc)
	broad_schema(sc)
}

has_broad_schema(value, schema_kind, doc) {
	schema_kind == "schemas"
	sc := value[schema_kind][s]
	not openapi_lib.is_ref(sc)
	broad_schema(sc)
}

has_broad_schema(value, schema_kind, doc) {
	schema_kind == "schema"
	openapi_lib.is_ref(value[schema_kind])
	r := split(value[schema_kind]["$ref"], "/")
	count(r) == 4
	s := r[3]
	component_schema := doc.components.schemas[sc]
	sc == s
	broad_schema(component_schema)
}

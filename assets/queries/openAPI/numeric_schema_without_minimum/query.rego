package Cx

import data.generic.openapi as openapi_lib

numeric := {"integer", "number"}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	[path, value] := walk(doc)
	schema_kind = openapi_lib.get_schema(value)
	info := openapi_lib.is_operation(path)
	openapi_lib.content_allowed(info.operation, info.code)
	openapi_lib.undefined_properties_in_schema(doc, value, schema_kind, numeric[x], "minimum")
	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.%s", [openapi_lib.concat_path(path), schema_kind]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Numeric schema has 'minimum' defined",
		"keyActualValue": "Numeric schema does not have 'minimum' defined",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	[path, value] := walk(doc)
	schema_kind = openapi_lib.get_schema(value)
	openapi_lib.is_operation(path) == {}
	openapi_lib.undefined_properties_in_schema(doc, value, schema_kind, numeric[x], "minimum")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.%s", [openapi_lib.concat_path(path), schema_kind]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Numeric schema has 'minimum' defined",
		"keyActualValue": "Numeric schema does not have 'minimum' defined",
	}
}

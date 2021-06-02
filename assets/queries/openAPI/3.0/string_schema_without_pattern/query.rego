package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	[path, value] := walk(doc)
	info := openapi_lib.is_operation(path)
	openapi_lib.content_allowed(info.operation, info.code)
	openapi_lib.undefined_field_in_string_schema(value, "pattern")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.type", [openapi_lib.concat_path(path)]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "String schema has 'pattern' defined",
		"keyActualValue": "String schema does not have 'pattern' defined",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	[path, value] := walk(doc)
	openapi_lib.is_operation(path) == {}
	openapi_lib.undefined_field_in_string_schema(value, "pattern")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.type", [openapi_lib.concat_path(path)]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "String schema has 'pattern' defined",
		"keyActualValue": "String schema does not have 'pattern' defined",
	}
}

package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	[path, value] := walk(doc)
	info := openapi_lib.is_operation(path)
	openapi_lib.content_allowed(info.operation, info.code)

	openapi_lib.undefined_field_in_numeric_schema(value, "format")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.type", [openapi_lib.concat_path(path)]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Numeric schema has 'format' defined",
		"keyActualValue": "Numeric schema does not have 'format' defined",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	[path, value] := walk(doc)
	openapi_lib.is_operation(path) == {}
	openapi_lib.is_numeric_type(value.type)

	openapi_lib.undefined_field_in_numeric_schema(value, "format")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.type", [openapi_lib.concat_path(path)]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Numeric schema has 'format' defined",
		"keyActualValue": "Numeric schema does not have 'format' defined",
	}
}

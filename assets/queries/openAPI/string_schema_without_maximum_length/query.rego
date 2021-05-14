package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	[path, value] := walk(doc)
	schema = value.schema
	info := openapi_lib.is_operation(path)
	openapi_lib.content_allowed(info.operation, info.code)
	openapi_lib.undefined_properties_in_schema(doc, schema, "string", "maxLength")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.schema", [openapi_lib.concat_path(path)]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "String schema has 'maxLength' defined",
		"keyActualValue": "String schema does not have 'maxLength' defined",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	[path, value] := walk(doc)
	schema = value.schema
	openapi_lib.is_operation(path) == {}
	openapi_lib.undefined_properties_in_schema(doc, schema, "string", "maxLength")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.schema", [openapi_lib.concat_path(path)]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "String schema has 'maxLength' defined",
		"keyActualValue": "String schema does not have 'maxLength' defined",
	}
}

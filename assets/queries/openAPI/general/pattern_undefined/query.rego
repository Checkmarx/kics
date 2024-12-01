package Cx

import data.generic.common as common_lib
import data.generic.openapi as openapi_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	[path, value] := walk(doc)
	info := openapi_lib.is_operation(path)
	openapi_lib.content_allowed(info.operation, info.code)
	openapi_lib.undefined_field_in_string_type(value, "pattern")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.type", [openapi_lib.concat_path(path)]),
		"searchLine": common_lib.build_search_line(path, ["type"]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'pattern' should be defined",
		"keyActualValue": "'pattern' is undefined",
		"overrideKey": version,
	}
}

CxPolicy[result] {
	some doc in input.document
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	[path, value] := walk(doc)
	openapi_lib.is_operation(path) == {}
	openapi_lib.undefined_field_in_string_type(value, "pattern")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.type", [openapi_lib.concat_path(path)]),
		"searchLine": common_lib.build_search_line(path, ["type"]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'pattern' should be defined",
		"keyActualValue": "'pattern' is undefined",
		"overrideKey": version,
	}
}

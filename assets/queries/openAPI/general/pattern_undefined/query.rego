package Cx

import data.generic.openapi as openapi_lib
import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	[path, value] := walk(doc)
	info := openapi_lib.is_operation(path)
	openapi_lib.content_allowed(info.operation, info.code)
	object.get(value, "name", "CXundefinedCX") != "CXundefinedCX"
	openapi_lib.undefined_field_in_string_type(value.schema, "pattern")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.name", [openapi_lib.concat_path(path)]),
		"searchLine": common_lib.build_search_line(path, ["name"]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'pattern' should be defined",
		"keyActualValue": "'pattern' is undefined",
		"overrideKey": version,
	}
}

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	[path, value] := walk(doc)
	openapi_lib.is_operation(path) == {}
	object.get(value, "name", "CXundefinedCX") != "CXundefinedCX"
	openapi_lib.undefined_field_in_string_type(value.schema, "pattern")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.name", [openapi_lib.concat_path(path)]),
		"searchLine": common_lib.build_search_line(path, ["name"]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'pattern' should be defined",
		"keyActualValue": "'pattern' is undefined",
		"overrideKey": version,
	}
}
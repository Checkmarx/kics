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
	undefined_maximum_number(value)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.type", [openapi_lib.concat_path(path)]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Array schema has 'maxItems' set",
		"keyActualValue": "Array schema has 'maxItems' undefined",
		"searchLine": common_lib.build_search_line(path, []) ,
		"overrideKey": version,
	}
}

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	[path, value] := walk(doc)
	openapi_lib.is_operation(path) == {}
	undefined_maximum_number(value)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.type", [openapi_lib.concat_path(path)]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Array schema has 'maxItems' set",
		"keyActualValue": "Array schema has 'maxItems' undefined",
		"searchLine": common_lib.build_search_line(path, []) ,
		"overrideKey": version,
	}
}

undefined_maximum_number(value) {
	value.type == "array"
	not common_lib.valid_key(value, "maxItems")
}

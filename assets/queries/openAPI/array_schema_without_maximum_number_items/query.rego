package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	[path, value] := walk(doc)
	info := openapi_lib.is_operation(path)
	openapi_lib.content_allowed(info.operation, info.code)
	undefined_maximum_number(value)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.type", [openapi_lib.concat_path(path)]),
		"issueType": "MissingAttribute",
		"keyActualValue": "Array schema has 'maxItems' set",
		"keyExpectedValue": "Array schema has 'maxItems' undefined",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	[path, value] := walk(doc)
	openapi_lib.is_operation(path) == {}
	undefined_maximum_number(value)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.type", [openapi_lib.concat_path(path)]),
		"issueType": "MissingAttribute",
		"keyActualValue": "Array schema has 'maxItems' set",
		"keyExpectedValue": "Array schema has 'maxItems' undefined",
	}
}

undefined_maximum_number(value) {
	value.type == "array"
	object.get(value, "maxItems", "undefined") == "undefined"
}

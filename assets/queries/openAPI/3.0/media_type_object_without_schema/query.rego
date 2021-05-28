package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	[path, value] := walk(doc)
	content = value.content
	info := openapi_lib.is_operation(path)
	openapi_lib.content_allowed(info.operation, info.code)
	object.get(content[x], "schema", "undefined") == "undefined"

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.content", [openapi_lib.concat_path(path)]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "The attribute 'schema' is set",
		"keyActualValue": "The attribute 'schema' is undefined",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	[path, value] := walk(doc)
	content = value.content
	openapi_lib.is_operation(path) == {}
	object.get(content[x], "schema", "undefined") == "undefined"

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.content", [openapi_lib.concat_path(path)]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "The attribute 'schema' is set",
		"keyActualValue": "The attribute 'schema' is undefined",
	}
}

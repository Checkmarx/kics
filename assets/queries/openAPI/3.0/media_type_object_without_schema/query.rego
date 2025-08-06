package Cx

import data.generic.common as common_lib
import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	[path, value] := walk(doc)
	content = value.content
	info := openapi_lib.is_operation(path)
	openapi_lib.content_allowed(info.operation, info.code)
	not there_is_schema(content)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.content", [common_lib.concat_path(path)]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "The attribute 'schema' should be set",
		"keyActualValue": "The attribute 'schema' is undefined",
		"searchLine": common_lib.build_search_line(path,["content"]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	[path, value] := walk(doc)
	content = value.content
	openapi_lib.is_operation(path) == {}
	not there_is_schema(content)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.content", [common_lib.concat_path(path)]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "The attribute 'schema' should be set",
		"keyActualValue": "The attribute 'schema' is undefined",
		"searchLine": common_lib.build_search_line(path,["content"]),
	}
}

there_is_schema(content) {
	common_lib.valid_key(content[_], "schema")
}
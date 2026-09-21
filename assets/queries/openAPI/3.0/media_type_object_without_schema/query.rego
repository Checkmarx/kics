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
	contentElement := content[x]
	not common_lib.valid_key(contentElement, "schema")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.content[%s]", [openapi_lib.concat_path(path),x]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "The attribute 'schema' should be set",
		"keyActualValue": "The attribute 'schema' is undefined",
		"searchLine": common_lib.build_search_line(path,["content", x])
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	[path, value] := walk(doc)
	content = value.content
	openapi_lib.is_operation(path) == {}
	contentElement := content[x]
	not common_lib.valid_key(contentElement, "schema")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.content[%s]", [openapi_lib.concat_path(path),x]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "The attribute 'schema' should be set",
		"keyActualValue": "The attribute 'schema' is undefined",
		"searchLine": common_lib.build_search_line(path,["content", x])
	}
}
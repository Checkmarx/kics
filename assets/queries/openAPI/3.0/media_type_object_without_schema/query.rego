package Cx

import data.generic.common as common_lib
import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	[path, value] := walk(doc)
	content = object.remove(value.content, ["_kics_lines"])
	info := openapi_lib.is_operation(path)
	openapi_lib.content_allowed(info.operation, info.code)
	contentElement := content[x]
	not common_lib.valid_key(contentElement, "schema")

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
	openapi_lib.check_openapi(doc) == "3.0"

	[path, value] := walk(doc)
	content = object.remove(value.content, ["_kics_lines"])
	openapi_lib.is_operation(path) == {}
	contentElement := content[x]
	not common_lib.valid_key(contentElement, "schema")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.content", [openapi_lib.concat_path(path)]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "The attribute 'schema' is set",
		"keyActualValue": "The attribute 'schema' is undefined",
	}
}

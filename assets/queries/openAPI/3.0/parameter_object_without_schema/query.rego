package Cx

import data.generic.openapi as openapi_lib
import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	[path, value] := walk(doc)
	parameters = value.parameters
	info := openapi_lib.is_operation(path)
	openapi_lib.content_allowed(info.operation, info.code)
	param := parameters[_]
	not common_lib.valid_key(param, "schema")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.parameters", [openapi_lib.concat_path(path)]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "The attribute 'schema' is set",
		"keyActualValue": "The attribute 'schema' is undefined",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	[path, value] := walk(doc)
	parameters = value.parameters
	openapi_lib.is_operation(path) == {}
	param := parameters[_]
	not common_lib.valid_key(param, "schema")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.parameters", [openapi_lib.concat_path(path)]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "The attribute 'schema' is set",
		"keyActualValue": "The attribute 'schema' is undefined",
	}
}

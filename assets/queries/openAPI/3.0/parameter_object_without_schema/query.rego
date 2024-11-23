package Cx

import data.generic.openapi as openapi_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	openapi_lib.check_openapi(doc) == "3.0"

	[path, value] := walk(doc)
	parameters = value.parameters
	info := openapi_lib.is_operation(path)
	openapi_lib.content_allowed(info.operation, info.code)
	some param in parameters
	openapi_lib.is_missing_attribute_and_ref(param, "schema")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.parameters", [openapi_lib.concat_path(path)]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "The attribute 'schema' should be set",
		"keyActualValue": "The attribute 'schema' is undefined",
	}
}

CxPolicy[result] {
	some doc in input.document
	openapi_lib.check_openapi(doc) == "3.0"

	[path, value] := walk(doc)
	parameters = value.parameters
	openapi_lib.is_operation(path) == {}
	some param in parameters
	openapi_lib.is_missing_attribute_and_ref(param, "schema")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.parameters", [openapi_lib.concat_path(path)]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "The attribute 'schema' should be set",
		"keyActualValue": "The attribute 'schema' is undefined",
	}
}

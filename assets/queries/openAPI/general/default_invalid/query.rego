package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	[path, value] := walk(doc)

	openapi_lib.invalid_field(value["default"], value.type)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.default", [openapi_lib.concat_path(path)]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The field 'default' should be consistent with the type",
		"keyActualValue": "The field 'default' is not consistent with the type",
		"overrideKey": version,
	}
}

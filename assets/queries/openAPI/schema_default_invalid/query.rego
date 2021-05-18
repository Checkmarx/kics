package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	[path, value] := walk(doc)

	openapi_lib.invalid_field(value["default"], value.type)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.default", [openapi_lib.concat_path(path)]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The field 'default' is consistent with the schema's type",
		"keyActualValue": "The field 'default' is not consistent with the schema's type",
	}
}

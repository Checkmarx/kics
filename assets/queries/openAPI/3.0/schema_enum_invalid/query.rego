package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	[path, value] := walk(doc)

	openapi_lib.invalid_field(value.enum[x], value.type)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.enum.%s", [openapi_lib.concat_path(path), value.enum[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The field 'enum' is consistent with the schema's type",
		"keyActualValue": "The field 'enum' is not consistent with the schema's type",
	}
}

package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	[path, value] := walk(doc)

	is_array(value)
	count(value) == 0

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s", [openapi_lib.concat_path(path)]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The array is not empty",
		"keyActualValue": "The array is empty",
	}
}

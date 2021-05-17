package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	[path, value] := walk(doc)

	property := value[x]
	is_empty_array(property)

	count(path) != 0

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.%s", [openapi_lib.concat_path(path), x]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The array is not empty",
		"keyActualValue": "The array is empty",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	[path, value] := walk(doc)

	property := value[x]
	is_empty_array(property)

	count(path) == 0

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s", [x]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The array is not empty",
		"keyActualValue": "The array is empty",
	}
}

is_empty_array(property) {
	is_array(property)
	count(property) == 0
}

is_empty_array(property) {
	property == null
}

package Cx

import data.generic.openapi as openapi_lib

options := {null, {}}

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	[path, value] := walk(doc)
	value.responses == options[x]

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.responses", [openapi_lib.concat_path(path)]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'responses' should not be empty",
		"keyActualValue": "'responses' is empty",
		"overrideKey": version,
	}
}

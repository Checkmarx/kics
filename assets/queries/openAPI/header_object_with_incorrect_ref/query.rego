package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	[path, value] := walk(doc)

	ref := value.headers[h]["$ref"]
	openapi_lib.incorrect_ref(ref, "headers")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.headers.$ref", [openapi_lib.concat_path(path)]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Response ref points to '#/components/headers'",
		"keyActualValue": "Response ref does not point to '#/components/headers'",
	}
}

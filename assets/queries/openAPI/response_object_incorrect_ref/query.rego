package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	[path, value] := walk(doc)

	ref := value.responses[code]["$ref"]
	openapi_lib.incorrect_ref(ref, "responses")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.responses.$ref", [openapi_lib.concat_path(path)]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Response ref points to '#/components/responses'",
		"keyActualValue": "Response ref does not point to '#/components/responses'",
	}
}

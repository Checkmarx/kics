package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	[path, value] := walk(doc)

	ref := value.callbacks[c]["$ref"]
	openapi_lib.incorrect_ref(ref, "callbacks")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.callbacks.$ref", [openapi_lib.concat_path(path)]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Callback ref points to '#/components/callbacks'",
		"keyActualValue": "Callback ref does not point to '#/components/callbacks'",
	}
}

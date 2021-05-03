package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	call_back := doc.paths[n][oper].callbacks[c]

	openapi_lib.incorrect_ref(call_back["$ref"], "callbacks")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("openapi.paths.%s.%s.responses.%s.$ref={{%s}}", [n, oper, c, call_back["$ref"]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Callback ref points to '#/components/callbacks'",
		"keyActualValue": "Callback ref does not point to '#/components/callbacks'",
	}
}

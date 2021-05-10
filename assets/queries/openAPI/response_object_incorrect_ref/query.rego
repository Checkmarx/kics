package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	response := doc.paths[n][oper].responses[code]
	openapi_lib.content_allowed(oper, code)
	openapi_lib.incorrect_ref(response["$ref"], "responses")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("openapi.paths.%s.%s.responses.%s.$ref={{%s}}", [n, oper, code, response["$ref"]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Response ref points to '#/components/responses'",
		"keyActualValue": "Response ref does not point to '#/components/responses'",
	}
}

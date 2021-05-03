package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	req := doc.paths[n][oper].requestBody

	openapi_lib.incorrect_ref(req["$ref"], "requestBody")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("openapi.paths.%s.%s.requestBody.$ref={{%s}}", [n, oper, req["$ref"]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Request body ref points to '#components/requestBodies'",
		"keyActualValue": "Request body ref doesn't point to '#components/requestBodies'",
	}
}

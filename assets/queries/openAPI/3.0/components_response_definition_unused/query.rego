package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	doc.components.responses[response]
	openapi_lib.check_unused_reference(doc, response, "responses")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.responses.{{%s}}", [response]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Response should be used as reference somewhere",
		"keyActualValue": "Response is not used as reference",
	}
}

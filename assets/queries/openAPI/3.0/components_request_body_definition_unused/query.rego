package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	doc.components.requestBodies[requestBody]
	openapi_lib.check_unused_reference(doc, requestBody, "requestBodies")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.requestBodies.{{%s}}", [requestBody]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Request body should be used as reference somewhere",
		"keyActualValue": "Request body is not used as reference",
	}
}

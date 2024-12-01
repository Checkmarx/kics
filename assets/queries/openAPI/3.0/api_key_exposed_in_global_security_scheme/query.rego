package Cx

import data.generic.openapi as openapi_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	openapi_lib.check_openapi(doc) == "3.0"

	doc.components.securitySchemes[s].type == "apiKey"

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.securitySchemes.%s", [s]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The API Key should not be transported over network",
		"keyActualValue": "The API Key is transported over network",
	}
}

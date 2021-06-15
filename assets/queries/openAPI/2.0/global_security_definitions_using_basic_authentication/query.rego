package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	doc.securityDefinitions[s].type == "basic"

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("securityDefinitions.%s.type", [s]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Global Security Definitions Object is not using basic authentication",
		"keyActualValue": "Global Security Definitions Object is using basic authentication",
	}
}

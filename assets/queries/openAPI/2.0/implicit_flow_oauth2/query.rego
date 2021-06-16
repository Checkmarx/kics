package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	sec_scheme := doc.securityDefinitions[key]
	sec_scheme.type == "oauth2"
	sec_scheme.flow == "implicit"

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("securityDefinitions.%s.flow=implicit", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "OAuth2 security definitions flow should not use implicit flow",
		"keyActualValue": "OAuth2 security definitions flow is using implicit flow",
	}
}

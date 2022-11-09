package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	doc.securityDefinitions[key].flow == "password"

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("securityDefinitions.{{%s}}.flow", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "security definition should not allow 'password' flow in OAuth2 authentication",
		"keyActualValue": "security definition allows 'password' flow in OAuth2 authentication",
	}
}

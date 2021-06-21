package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	doc.securityDefinitions[key].flow == "password"
	doc.securityDefinitions[key].type == "oauth2"

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("securityDefinitions.{{%s}}.flow", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "security definition is not using 'password' flow in OAuth2 authentication",
		"keyActualValue": "security definition is using 'password' flow in OAuth2 authentication",
	}
}

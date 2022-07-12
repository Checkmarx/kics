package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	doc.securityDefinitions[key].flow == "password"
	doc.security[x][key]

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("security.{{%s}}", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'security' should not be using 'password' flow in OAuth2 authentication",
		"keyActualValue": "'security' is using 'password' flow in OAuth2 authentication",
	}
}

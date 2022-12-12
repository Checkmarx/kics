package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	doc.paths[p][oper].security[n][key]
	doc.securityDefinitions[key].flow == "password"

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.security.{{%s}}", [p, oper, key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Operation Object should not be using 'password' flow in OAuth2 authentication",
		"keyActualValue": "Operation Object is using 'password' flow in OAuth2 authentication",
	}
}

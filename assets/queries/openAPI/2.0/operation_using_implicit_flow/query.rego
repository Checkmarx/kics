package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	doc.paths[p][oper].security[n][key]
	doc.securityDefinitions[key].type == "oauth2"
	doc.securityDefinitions[key].flow == "implicit"

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.security.{{%s}}", [p, oper, key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Operation Object is not using implicit flow",
		"keyActualValue": "Operation Object is using implicit flow",
	}
}

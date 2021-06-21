package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	secDef := doc.securityDefinitions[key]
	secDef.flow == "password"

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("securityDefinitions.{{%s}}.flow", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "security definition is not using 'password' flow",
		"keyActualValue": "security definition is using 'password' flow",
	}
}

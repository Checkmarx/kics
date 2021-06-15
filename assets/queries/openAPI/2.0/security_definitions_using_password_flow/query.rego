package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	sec_def := doc.securityDefinitions[key]
	sec_def.flow == "password"

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("securityDefinitions.{{%s}}.flow", [key]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "security definition is not using 'password' flow",
		"keyActualValue": "security definition is using 'password' flow",
	}
}

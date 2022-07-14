package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	sec_def := doc.securityDefinitions[key]
	sec_def.type == "basic"

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("securityDefinitions.{{%s}}.type", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "security definition should not be using basic authentication",
		"keyActualValue": "security definition is using basic authentication",
	}
}

package Cx

import data.generic.openapi as openapi_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
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

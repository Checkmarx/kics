package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	scheme := doc.components.securitySchemes[schemeName]
	lower(scheme.type) == "http"
	lower(scheme.scheme) == "basic"

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.securitySchemes.{{%s}}", [schemeName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("components.securitySchemes.{{%s}} global security should not allow basic authentication", [schemeName]),
		"keyActualValue": sprintf("components.securitySchemes.{{%s}} global security allows basic authentication", [schemeName]),
	}
}

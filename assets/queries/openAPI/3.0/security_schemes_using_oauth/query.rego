package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	security_scheme := doc.components.securitySchemes[name]
	security_scheme.type == "http"
	security_scheme.scheme == "oauth"

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.securitySchemes.{{%s}}", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("components.securitySchemes.{{%s}} should not use oauth 1.0 security scheme", [name]),
		"keyActualValue": sprintf("components.securitySchemes.{{%s}} uses oauth 1.0 security scheme", [name]),
	}
}

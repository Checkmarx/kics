package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	security_scheme := doc.components.securitySchemes[name]
	security_scheme.type == "http"
	security_scheme.scheme == "basic"

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.securitySchemes.{{%s}}.scheme", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("components.securitySchemes.{{%s}} should not use 'basic' authentication", [name]),
		"keyActualValue": sprintf("components.securitySchemes.{{%s}} uses 'basic' authentication", [name]),
	}
}

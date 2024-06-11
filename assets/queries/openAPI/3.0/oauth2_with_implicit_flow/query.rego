package Cx

import data.generic.openapi as openapi_lib
import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	security_scheme := doc.components.securitySchemes[key]
	security_scheme.type == "oauth2"
	common_lib.valid_key(security_scheme.flows, "implicit")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.securitySchemes.{{%s}}.flows.implicit", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("components.securitySchemes.{{%s}}.flows should not use 'implicit' flow", [key]),
		"keyActualValue": sprintf("components.securitySchemes.{{%s}}.flows is using 'implicit' flow", [key]),
	}
}

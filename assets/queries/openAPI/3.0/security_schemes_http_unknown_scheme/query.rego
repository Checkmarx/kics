package Cx

import data.generic.common as common_lib
import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	types := {"basic", "bearer", "digest", "hoba", "mutual", "negotiate", "oauth", "scram-sha-1", "scram-sha-256", "vapid"}

	security_scheme := doc.components.securitySchemes[name]
	security_scheme.type == "http"
	not common_lib.inArray(types, lower(security_scheme.scheme))

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.securitySchemes.{{%s}}.scheme", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("components.securitySchemes.{{%s}}.scheme is registered in the IANA Authentication Scheme registry", [name]),
		"keyActualValue": sprintf("components.securitySchemes.{{%s}}.scheme is not registered in the IANA Authentication Scheme registry", [name]),
	}
}

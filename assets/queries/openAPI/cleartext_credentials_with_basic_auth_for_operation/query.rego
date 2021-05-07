package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	openapi_lib.is_security_scheme_http_basic(doc.components.securitySchemes)
	operation_scheme := doc.paths[path][operation]
	operation_scheme.security[j].regularSecurity == []

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.security.regularSecurity", [path, operation]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}} operation should not allow cleartext credentials over unencrypted channel", [path, operation]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}} operation allows cleartext credentials over unencrypted channel", [path, operation]),
	}
}

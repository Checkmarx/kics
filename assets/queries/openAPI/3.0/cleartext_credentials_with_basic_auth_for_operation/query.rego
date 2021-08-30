package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	scheme := doc.components.securitySchemes[x]
	lower(scheme.type) == "http"
	lower(scheme.scheme) == "basic"

	op := doc.paths[path][operation]
	op.security[sec][x] == []

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.security.{{%s}}", [path, operation, x]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}} operation should not allow cleartext credentials over unencrypted channel", [path, operation]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}} operation allows cleartext credentials over unencrypted channel", [path, operation]),
	}
}

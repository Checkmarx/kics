package Cx

import data.generic.openapi as openapi_lib
import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	security_field := doc.paths[path][operation].security[s][field]

	not exists(field, doc)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.%s", [path, operation, field]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.security[%d].%s should be defined in '#/components/securitySchemes'", [path, operation, s, field]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.security[%d].%s is not defined in '#/components/securitySchemes'", [path, operation, s, field]),
	}
}

exists(security_field, doc) {
	common_lib.valid_key(doc.components.securitySchemes, security_field)
}

package Cx

import data.generic.openapi as openapi_lib
import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	security_field := doc.security[s][field]

	not exists(field, doc)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("security.%s", [field]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("security[%d].%s should be defined in '#/components/securitySchemes'", [s, field]),
		"keyActualValue": sprintf("security[%d].%s is not defined in '#/components/securitySchemes'", [s, field]),
	}
}

exists(security_field, doc) {
	common_lib.valid_key(doc.components.securitySchemes, security_field)
}

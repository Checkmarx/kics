package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	security_field := doc.security[s][field]

	not exists(field, doc)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("security.%s", [field]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("security[%d].%s is defined in '#/components/securitySchemes'", [s, field]),
		"keyActualValue": sprintf("security[%d].%s is not defined in '#/components/securitySchemes'", [s, field]),
	}
}

exists(security_field, doc) {
	object.get(doc.components.securitySchemes, security_field, "undefined") != "undefined"
}

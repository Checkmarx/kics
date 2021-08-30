package Cx

import data.generic.openapi as openapi_lib
import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	sec_scheme := doc.components.securitySchemes[key]
	sec_scheme.type == "oauth2"
	common_lib.valid_key(sec_scheme.flows, "implicit")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.securitySchemes.%s.flows.implicit", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "OAuth2 security schema flow should not use implicit flow",
		"keyActualValue": "OAuth2 security schema flow is using implicit flow",
	}
}

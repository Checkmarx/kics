package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	object.get(doc, "components", "undefined") != "undefined"
	object.get(doc.components, "securitySchemes", "undefined") != "undefined"
	sec_scheme := doc.components.securitySchemes[key]
	sec_scheme.type == "oauth2"
	url := sec_scheme.flows.authorizationCode.tokenUrl

	not openapi_lib.is_valid_url(url)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.securitySchemes.%s.flows.authorizationCode.tokenUrl", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "OAuth2 security schema flow tokenUrl must be set with a valid URL",
		"keyActualValue": "OAuth2 security schema flow tokenUrl has an invalid URL",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	object.get(doc, "components", "undefined") != "undefined"
	object.get(doc.components, "securitySchemes", "undefined") != "undefined"
	sec_scheme := doc.components.securitySchemes[key]
	sec_scheme.type == "oauth2"
	url := sec_scheme.flows.password.tokenUrl

	not openapi_lib.is_valid_url(url)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.securitySchemes.%s.flows.password.tokenUrl", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "OAuth2 security schema flow tokenUrl must be set with a valid URL",
		"keyActualValue": "OAuth2 security schema flow tokenUrl has an invalid URL",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	object.get(doc, "components", "undefined") != "undefined"
	object.get(doc.components, "securitySchemes", "undefined") != "undefined"
	sec_scheme := doc.components.securitySchemes[key]
	sec_scheme.type == "oauth2"
	url := sec_scheme.flows.clientCredentials.tokenUrl

	not openapi_lib.is_valid_url(url)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.securitySchemes.%s.flows.clientCredentials.tokenUrl", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "OAuth2 security schema flow tokenUrl must be set with a valid URL",
		"keyActualValue": "OAuth2 security schema flow tokenUrl has an invalid URL",
	}
}

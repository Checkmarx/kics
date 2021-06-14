package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version == "3.0"

	object.get(doc, "components", "undefined") != "undefined"
	object.get(doc.components, "securitySchemes", "undefined") != "undefined"
	sec_scheme := doc.components.securitySchemes[key]
	sec_scheme.type == "oauth2"
	type := ["authorizationCode", "password", "clientCredentials"]
	url := sec_scheme.flows[type[name]].tokenUrl

	not openapi_lib.is_valid_url(url)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.securitySchemes.%s.flows.%s.tokenUrl", [key, type[name]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "OAuth2 security schema flow tokenUrl must be set with a valid URL",
		"keyActualValue": "OAuth2 security schema flow tokenUrl has an invalid URL",
		"overrideKey": version,
	}
}

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version == "2.0"

	object.get(doc, "components", "undefined") != "undefined"
	object.get(doc.components, "securityDefinitions", "undefined") != "undefined"
	sec_scheme := doc.components.securityDefinitions[key]
	sec_scheme.type == "oauth2"
	url := sec_scheme.tokenUrl

	not openapi_lib.is_valid_url(url)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("securityDefinitions.%s.tokenUrl", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "OAuth2 security definition flow tokenUrl must be set with a valid URL",
		"keyActualValue": "OAuth2 security definition flow tokenUrl has an invalid URL",
		"overrideKey": version,
	}
}

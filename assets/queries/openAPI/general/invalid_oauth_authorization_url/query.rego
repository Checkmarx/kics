package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version == "3.0"

	sec_scheme := doc.components.securitySchemes[key]
	sec_scheme.type == "oauth2"
	url := sec_scheme.flows.authorizationCode.authorizationUrl

	not openapi_lib.is_valid_url(url)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.securitySchemes.%s.flows.authorizationCode.authorizationUrl", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "OAuth2 security schema flow tokenUrl must be set with a valid URL",
		"keyActualValue": "OAuth2 security schema flow tokenUrl has an invalid URL",
		"overrideKey": version,
	}
}

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version == "3.0"

	sec_scheme := doc.components.securitySchemes[key]
	sec_scheme.type == "oauth2"
	url := sec_scheme.flows.implicit.authorizationUrl

	not openapi_lib.is_valid_url(url)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.securitySchemes.%s.flows.implicit.authorizationUrl", [key]),
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

	flows := ["accessCode", "implicit"]

	sec_definitions := doc.components.securityDefinitions[key]
	sec_definitions.type == "oauth2"
	sec_definitions.flow == flows[x]
	url := sec_definitions.authorizationUrl

	not openapi_lib.is_valid_url(url)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.securityDefinitions.%s.authorizationUrl", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "OAuth2 security schema flow tokenUrl must be set with a valid URL",
		"keyActualValue": "OAuth2 security schema flow tokenUrl has an invalid URL",
		"overrideKey": version,
	}
}

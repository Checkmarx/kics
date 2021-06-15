package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	flows := ["accessCode", "implicit"]

	sec_definitions := doc.securityDefinitions[key]
	sec_definitions.type == "oauth2"
	sec_definitions.flow == flows[x]
	url := sec_definitions.authorizationUrl

	not openapi_lib.is_valid_url(url)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("securityDefinitions.%s.authorizationUrl", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "OAuth2 security schema flow tokenUrl must be set with a valid URL",
		"keyActualValue": "OAuth2 security schema flow tokenUrl has an invalid URL",
	}
}

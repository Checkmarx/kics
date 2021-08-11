package Cx

import data.generic.openapi as openapi_lib
import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	common_lib.valid_key(doc, "securityDefinitions")
	sec_scheme := doc.securityDefinitions[key]
	sec_scheme.type == "oauth2"
	url := sec_scheme.tokenUrl

	not openapi_lib.is_valid_url(url)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("securityDefinitions.%s.tokenUrl", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "OAuth2 security definition flow tokenUrl must be set with a valid URL",
		"keyActualValue": "OAuth2 security definition flow tokenUrl has an invalid URL",
	}
}

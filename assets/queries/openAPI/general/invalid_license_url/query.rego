package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	not openapi_lib.is_valid_url(doc.info.license.url)

	result := {
		"documentId": doc.id,
		"searchKey": "info.license.url",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "info.license.url has a valid URL",
		"keyActualValue": "info.license.url has an invalid URL",
		"overrideKey": version,
	}
}

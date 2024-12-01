package Cx

import data.generic.openapi as openapi_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
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

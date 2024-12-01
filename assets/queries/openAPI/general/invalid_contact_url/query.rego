package Cx

import data.generic.openapi as openapi_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	not openapi_lib.is_valid_url(doc.info.contact.url)

	result := {
		"documentId": doc.id,
		"searchKey": "info.contact.url",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "info.contact.url has a valid URL",
		"keyActualValue": "info.contact.url has an invalid URL",
		"overrideKey": version,
	}
}

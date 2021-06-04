package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
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

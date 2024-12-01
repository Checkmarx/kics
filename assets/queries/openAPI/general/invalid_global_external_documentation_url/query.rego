package Cx

import data.generic.openapi as openapi_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	url := doc.externalDocs.url
	not openapi_lib.is_valid_url(url)

	result := {
		"documentId": doc.id,
		"searchKey": "externalDocs.url",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "externalDocs.url has a valid URL",
		"keyActualValue": "externalDocs.url does not have a valid URL",
		"overrideKey": version,
	}
}

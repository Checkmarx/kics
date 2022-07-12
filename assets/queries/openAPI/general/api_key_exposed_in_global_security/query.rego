package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	doc.security[x][s]
	openapi_lib.api_key_exposed(doc, version, s)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("security.%s", [s]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The API Key should not be transported over network",
		"keyActualValue": "The API Key is transported over network",
		"overrideKey": version,
	}
}

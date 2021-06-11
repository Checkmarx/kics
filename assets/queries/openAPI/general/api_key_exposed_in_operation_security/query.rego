package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	doc.paths[path][operation].security[x][s]
	openapi_lib.api_key_exposed(doc, version, s)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.%s.%s.security.%s", [path, operation, s]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The API Key is not transported over network",
		"keyActualValue": "The API Key is transported over network",
		"overrideKey": version,
	}
}

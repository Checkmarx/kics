package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	security := doc.paths[path][operation].security[x][s]
	openapi_lib.api_key_exposed(doc, version, s)
	count(security) == 0

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.%s.%s.security.%s", [path, operation, s]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The API Key should not be sent as cleartext over an unencrypted channel",
		"keyActualValue": "The API Key is sent as cleartext over an unencrypted channel",
		"overrideKey": version,
	}
}

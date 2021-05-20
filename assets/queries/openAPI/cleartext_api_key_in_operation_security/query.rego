package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	security := doc.paths[path][operation].security[x][s]
	doc.components.securitySchemes[s].type == "apiKey"
	count(security) == 0

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.%s.%s.security.%s", [path, operation, s]),
		"issueType": "IncorretValue",
		"keyExpectedValue": "The API Key is not sent as cleartext over an unencrypted channel",
		"keyActualValue": "The API Key is sent as cleartext over an unencrypted channel",
	}
}

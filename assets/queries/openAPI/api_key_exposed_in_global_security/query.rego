package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	security := doc.security[x][s]
	doc.components.securitySchemes[s].type == "apiKey"

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("security.%s", [s]),
		"issueType": "IncorretValue",
		"keyExpectedValue": "The API Key is not transported over network",
		"keyActualValue": "The API Key is transported over network",
	}
}

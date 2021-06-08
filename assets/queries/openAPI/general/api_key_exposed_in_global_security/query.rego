package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	security := doc.security[x][s]
	api_key_exposed(doc, version, s)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("security.%s", [s]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The API Key is not transported over network",
		"keyActualValue": "The API Key is transported over network",
		"overrideKey": version,
	}
}

api_key_exposed(doc, version, s) {
	version == "3.0"
	doc.components.securitySchemes[s].type == "apiKey"
} else {
	version == "2.0"
	doc.securityDefinitions[s].type == "apiKey"
}

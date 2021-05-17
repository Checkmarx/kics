package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	security := doc.paths[path][operation].security[x][s]
	ins := {"cookie", "header", "query"}
	doc.components.securitySchemes[s].in == ins[z]

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.%s.%s.security.%s", [path, operation, s]),
		"issueType": "IncorretValue",
		"keyExpectedValue": sprintf("The API Key is not transported over network in a %s", [ins[z]]),
		"keyActualValue": sprintf("The API Key is transported over network in a %s", [ins[z]]),
	}
}

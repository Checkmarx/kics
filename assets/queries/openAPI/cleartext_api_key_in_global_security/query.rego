package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	security := doc.security[x][s]
	ins := {"cookie", "header", "query"}
	doc.components.securitySchemes[s].in == ins[z]
	count(security) == 0

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("security.%s", [s]),
		"issueType": "IncorretValue",
		"keyExpectedValue": sprintf("The API Key is not sent as cleartext in a %s over an unencrypted channel", [ins[z]]),
		"keyActualValue": sprintf("The API Key is sent as cleartext in a %s over an unencrypted channel", [ins[z]]),
	}
}

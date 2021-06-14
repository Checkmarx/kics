package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	doc.schemes[s] == "http"

	result := {
		"documentId": doc.id,
		"searchKey": "schemes.http",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The Scheme list uses only 'HTTPS' protocol",
		"keyActualValue": "The Scheme list uses 'HTTP' protocol",
	}
}

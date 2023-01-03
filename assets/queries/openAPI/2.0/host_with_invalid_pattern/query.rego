package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	host := doc.host
	not regex.match("^[^{}/ :\\\\]+(?::\\d+)?$", host)

	result := {
		"documentId": doc.id,
		"searchKey": "host",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Host should be a valid name or IP",
		"keyActualValue": sprintf("%s is not valid IP or name", [host]),
	}
}

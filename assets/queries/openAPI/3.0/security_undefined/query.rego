package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	object.get(doc, "security", "undefined") == "undefined"

	result := {
		"documentId": doc.id,
		"searchKey": "openapi",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "A default security schema should be defined",
		"keyActualValue": "A default security schema is not defined",
	}
}

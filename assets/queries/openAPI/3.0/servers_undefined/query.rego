package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	object.get(doc, "servers", "undefined") == "undefined"

	result := {
		"documentId": doc.id,
		"searchKey": "openapi",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Servers array has at least one server defined",
		"keyActualValue": "Servers array does not have at least one server defined",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	object.get(doc, "servers", "undefined") != "undefined"
	count(doc.servers) == 0

	result := {
		"documentId": doc.id,
		"searchKey": "servers",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Servers array has at least one server defined",
		"keyActualValue": "Servers array is empty",
	}
}

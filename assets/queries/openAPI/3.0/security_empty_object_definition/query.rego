package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	object.get(doc, "security", "undefined") != "undefined"

	is_array(doc.security)
	count(doc.security) > 0

	securityItem := doc.security[_]
	securityItem == {}

	result := {
		"documentId": doc.id,
		"searchKey": "security",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Global security field definition should not have an empty object",
		"keyActualValue": "Global security field definition has an empty object",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	object.get(doc, "security", "undefined") != "undefined"

	not is_array(doc.security)
	doc.security == {}

	result := {
		"documentId": doc.id,
		"searchKey": "security",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Global security field definition should not have an empty object",
		"keyActualValue": "Global security field definition has an empty object",
	}
}

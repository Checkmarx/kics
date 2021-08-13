package Cx

import data.generic.openapi as openapi_lib
import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"
	common_lib.valid_key(doc, "security")

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
		"overrideKey": version,
	}
}

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"
	common_lib.valid_key(doc, "security")

	not is_array(doc.security)
	doc.security == {}

	result := {
		"documentId": doc.id,
		"searchKey": "security",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Global security field definition should not have an empty object",
		"keyActualValue": "Global security field definition has an empty object",
		"overrideKey": version,
	}
}

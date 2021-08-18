package Cx

import data.generic.common as common_lib
import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"
	object.get(doc, "security", "undefined") != "undefined"

	common_lib.check_obj_empty(doc.security)

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
	object.get(doc, "security", "undefined") != "undefined"

	common_lib.check_obj_empty(doc.security[_])

	result := {
		"documentId": doc.id,
		"searchKey": "security",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Global security field definition should not have an empty object",
		"keyActualValue": "Global security field definition has an empty object",
		"overrideKey": version,
	}
}

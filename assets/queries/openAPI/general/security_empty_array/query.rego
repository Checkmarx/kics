package Cx

import data.generic.openapi as openapi_lib
import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"
	common_lib.valid_key(doc, "security")

	is_array(doc.security)
	count(doc.security) == 0

	result := {
		"documentId": doc.id,
		"searchKey": "security",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "A default security schema should be defined",
		"keyActualValue": "A default security schema is not defined",
		"overrideKey": version,
	}
}

package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	regex.match(`^[\w-\._]+@([\w-]+\.)+[\w-_]{2,4}$`, doc.info.contact.email) == false

	result := {
		"documentId": doc.id,
		"searchKey": "info.contact.email",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "info.contact.email has a valid email",
		"keyActualValue": "info.contact.email has an invalid email",
		"overrideKey": version,
	}
}

package Cx

import data.generic.openapi as openAPILib

CxPolicy[result] {
	doc := input.document[i]
	openAPILib.checkOpenAPI(doc) != "undefined"
	object.get(doc, "security", "undefined") != "undefined"

	count(doc.security) > 0
	securityItem := doc.security[idx]

	securityItem == {}

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("security[%d]", [idx]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Global security field definition should not have an empty object",
		"keyActualValue": "Global security field definition has an empty object",
	}
}

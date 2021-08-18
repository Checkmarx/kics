package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	issueType := undefined_or_empty(doc)

	result := {
		"documentId": doc.id,
		"searchKey": "swagger",
		"issueType": issueType,
		"keyExpectedValue": "'securityDefinitions' is set and not empty",
		"keyActualValue": "'securityDefinitions' is undefined or empty",
	}
}

undefined_or_empty(doc) = issueType {
	object.get(doc, "securityDefinitions", "undefined") == "undefined"
	issueType = "MissingAttribute"
} else = issueType {
	count({x | sec := doc.securityDefinitions[n]; n != "_kics_lines"; x = sec}) == 0
	issueType = "IncorrectValue"
}

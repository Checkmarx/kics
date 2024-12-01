package Cx

import data.generic.common as common_lib
import data.generic.openapi as openapi_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	openapi_lib.check_openapi(doc) == "2.0"

	issueType := undefined_or_empty(doc)

	result := {
		"documentId": doc.id,
		"searchKey": "swagger",
		"issueType": issueType,
		"keyExpectedValue": "'securityDefinitions' should be set and not empty",
		"keyActualValue": "'securityDefinitions' is undefined or empty",
	}
}

undefined_or_empty(doc) = issueType {
	not common_lib.valid_key(doc, "securityDefinitions")
	issueType = "MissingAttribute"
} else = issueType {
	count(doc.securityDefinitions) == 0
	issueType = "IncorrectValue"
}

package Cx

import data.generic.common as common_lib
import data.generic.openapi as openapi_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	openapi_lib.check_openapi(doc) == "3.0"
	not common_lib.valid_key(doc, "servers")

	result := {
		"documentId": doc.id,
		"searchKey": "openapi",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Servers array has at least one server defined",
		"keyActualValue": "Servers array does not have at least one server defined",
	}
}

CxPolicy[result] {
	some doc in input.document
	openapi_lib.check_openapi(doc) == "3.0"
	common_lib.valid_key(doc, "servers")
	count(doc.servers) == 0

	result := {
		"documentId": doc.id,
		"searchKey": "servers",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Servers array has at least one server defined",
		"keyActualValue": "Servers array is empty",
	}
}

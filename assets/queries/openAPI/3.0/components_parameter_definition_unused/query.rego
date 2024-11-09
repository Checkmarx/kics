package Cx

import data.generic.openapi as openapi_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	openapi_lib.check_openapi(doc) == "3.0"

	some parameter in doc.components.parameters
	openapi_lib.check_unused_reference(doc, parameter, "parameters")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.parameters.{{%s}}", [parameter]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Parameter should be used as reference somewhere",
		"keyActualValue": "Parameter is not used as reference",
	}
}

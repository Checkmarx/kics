package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	doc.components.parameters[parameter]
	openapi_lib.check_unused_reference(doc, parameter, "parameters")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.parameters.{{%s}}", [parameter]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Parameter should be used as reference somewhere",
		"keyActualValue": "Parameter is not used as reference",
	}
}

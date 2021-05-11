package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	doc.components.parameters[parameter]
	parameterRef := sprintf("#/components/parameters/%s", [parameter])

	count({parameterRef | [_, value] := walk(doc); parameterRef == value["$ref"]}) == 0
	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.parameters.{{%s}}", [parameter]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Parameter should be used as reference somewhere",
		"keyActualValue": "Parameter is not used as reference",
	}
}

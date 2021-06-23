package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	params := doc.parameters[name]

	openapi_lib.check_definitions(doc, "parameters", name)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("parameters.{{%s}}", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("parameter definition '%s' is used", [name]),
		"keyActualValue": sprintf("parameter definition '%s' is not being used", [name]),
	}
}

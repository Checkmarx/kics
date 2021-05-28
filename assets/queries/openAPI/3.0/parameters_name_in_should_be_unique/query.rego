package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	parameters := doc.components.parameters
	paramOne := parameters[keyOne]
	paramTwo := parameters[keyTwo]
	keyOne != keyTwo
	paramOne.name == paramTwo.name
	paramOne.in == paramTwo.in

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.parameters.{{%s}}", [keyOne]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Parameters should have unique 'name' and 'in' combinations",
		"keyActualValue": sprintf("components.parameters.{{%s}} parameters does not have unique 'name' and 'in' combinations", [keyOne]),
	}
}

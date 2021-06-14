package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	[path, value] := walk(doc)
	parameters := value.parameters

	paramOne := parameters[keyOne]
	paramTwo := parameters[keyTwo]
	keyOne != keyTwo
	paramOne.name == paramTwo.name
	paramOne.in == paramTwo.in

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.parameters.{{%s}}", [openapi_lib.concat_path(path), keyOne]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Parameter has unique 'name' and 'in' combinations",
		"keyActualValue": "Parameter does not have unique 'name' and 'in' combinations",
		"overrideKey": version,
	}
}

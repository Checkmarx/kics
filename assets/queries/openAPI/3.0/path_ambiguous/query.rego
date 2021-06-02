package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	doc.paths[name]
	doc.paths[compareName]
	name != compareName

	firstName := clean_name(name)
	secondName := clean_name(compareName)

	firstName == secondName
	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.%s", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "There is no ambiguous path",
		"keyActualValue": "There is ambiguous path",
	}
}

clean_name(name) = result {
	templates := regex.find_n("\\{.*\\}", name, -1)
	result := replace(name, templates[_], "")
}

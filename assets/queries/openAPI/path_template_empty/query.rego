package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	path := doc.paths[name]

	contains(name, "{}")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.%s", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "The path template is not empty",
		"keyActualValue": "The path template is empty",
	}
}

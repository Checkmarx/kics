package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	object.get(doc, "paths", "undefined") != "undefined"

	check_paths_object(doc.paths)

	result := {
		"documentId": doc.id,
		"searchKey": "openapi.paths",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The Paths Object should should not be empty",
		"keyActualValue": "The Paths Object is empty",
	}
}

check_paths_object(paths) {
	count(paths) == 0
}

# In yaml an empty object is parsed into null
check_paths_object(paths) {
	paths == null
}

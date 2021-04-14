package Cx

import data.generic.openapi as openAPILib

CxPolicy[result] {
	doc := input.document[i]
	openAPILib.checkOpenAPI(doc) != "undefined"
	object.get(doc, "paths", "undefined") != "undefined"

	checkPathsObject(doc.paths)

	result := {
		"documentId": doc.id,
		"searchKey": "openapi.paths",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The Paths Object should should not be empty",
		"keyActualValue": "The Paths Object is empty",
	}
}

checkPathsObject(paths) {
	count(paths) == 0
}

# In yaml an empty object is parsed into null
checkPathsObject(paths) {
	paths == null
}

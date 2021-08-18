package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"
	object.get(doc, "paths", "undefined") != "undefined"

	check_paths_object(doc.paths)

	result := {
		"documentId": doc.id,
		"searchKey": "paths",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The Paths Object should should not be empty",
		"keyActualValue": "The Paths Object is empty",
		"overrideKey": version,
	}
}

check_paths_object(paths) {
	count({x | p := paths[n]; n != "_kics_lines"; x = p}) == 0
}

# In yaml an empty object is parsed into null
check_paths_object(paths) {
	paths == null
}

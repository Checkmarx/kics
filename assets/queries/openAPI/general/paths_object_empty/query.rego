package Cx

import data.generic.common as common_lib
import data.generic.openapi as openapi_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	common_lib.valid_key(doc, "paths")

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

# In yaml an empty object is parsed into null
check_paths_object(null) = true

check_paths_object(paths) {
	count(paths) == 0
}

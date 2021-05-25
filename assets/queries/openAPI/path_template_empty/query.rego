package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	path := doc.paths[name]
	matches := openapi_lib.is_path_template(name)
	matches != []

	is_empty(path)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.%s", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "The path template is not empty",
		"keyActualValue": "The path template is empty",
	}
}

is_empty(path) {
	count(path) == 0
} else {
	path == null
}

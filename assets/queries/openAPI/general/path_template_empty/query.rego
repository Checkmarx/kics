package Cx

import data.generic.openapi as openapi_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	path := doc.paths[name]
	contains(name, "{}")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.%s", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "The path template should not be empty",
		"keyActualValue": "The path template is empty",
		"overrideKey": version,
	}
}

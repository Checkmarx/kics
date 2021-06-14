package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	op := doc.paths[path][operation]
	operation == "get"
	object.get(doc, "produces", "undefined") == "undefined"
	object.get(op, "produces", "undefined") == "undefined"

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.%s", [path, operation]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("paths.{{%s}}.%s 'produces' is defined", [path, operation]),
		"keyActualValue": sprintf("paths.{{%s}}.%s 'produces' is missing", [path, operation]),
	}
}

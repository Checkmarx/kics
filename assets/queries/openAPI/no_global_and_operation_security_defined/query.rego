package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	object.get(doc, "security", "undefined") == "undefined"

	operationObject := doc.paths[path][operation]
	object.get(operationObject, "security", "undefined") == "undefined"

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.security", [path, operation]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "A security schema should be used",
		"keyActualValue": "No security schema is used",
	}
}

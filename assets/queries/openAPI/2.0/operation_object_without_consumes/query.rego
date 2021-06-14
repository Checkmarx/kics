package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	types := ["put", "patch", "post"]

	op := doc.paths[path][operation]
	operation == types[n]

	object.get(doc, "consumes", "undefined") == "undefined"
	object.get(op, "consumes", "undefined") == "undefined"

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.%s", [path, operation]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("paths.{{%s}}.%s 'consumes' is defined", [path, operation]),
		"keyActualValue": sprintf("paths.{{%s}}.%s 'consumes' is missing", [path, operation]),
	}
}

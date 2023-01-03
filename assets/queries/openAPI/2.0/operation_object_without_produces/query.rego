package Cx

import data.generic.openapi as openapi_lib
import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	op := doc.paths[path][operation]
	operation == "get"
	not common_lib.valid_key(doc, "produces")
	not common_lib.valid_key(op, "produces")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.%s", [path, operation]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("paths.{{%s}}.%s 'produces' should be defined", [path, operation]),
		"keyActualValue": sprintf("paths.{{%s}}.%s 'produces' is missing", [path, operation]),
	}
}

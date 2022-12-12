package Cx

import data.generic.openapi as openapi_lib
import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	types := ["put", "patch", "post"]

	op := doc.paths[path][operation]
	operation == types[n]

	not common_lib.valid_key(doc, "consumes")
	not common_lib.valid_key(op, "consumes")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.%s", [path, operation]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("paths.{{%s}}.%s 'consumes' should be defined", [path, operation]),
		"keyActualValue": sprintf("paths.{{%s}}.%s 'consumes' is missing", [path, operation]),
	}
}

package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	targert_op_id := doc.paths[path][operation].operationId

	count({op | op_id := doc.paths[_][op].operationId; targert_op_id == op_id}) > 1

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.operationId", [path, operation]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.operationId is unique", [path, operation]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.operationId is not unique", [path, operation]),
		"overrideKey": version,
	}
}

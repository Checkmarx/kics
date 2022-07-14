package Cx

import data.generic.common as common_lib
import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	operation := doc.paths[path][op]

	operation_should_have_content := ["get", "put", "post", "delete", "options", "patch", "trace"]
	common_lib.equalsOrInArray(operation_should_have_content, lower(op))

	response_code_should_not_have_content := ["204", "304"]

	response := operation.responses[code]
	common_lib.equalsOrInArray(response_code_should_not_have_content, lower(code))

	cont := check_cont(response, version)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.%s", [path, op, code, cont]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.%s should not be defined", [path, op, code, cont]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.%s is defined", [path, op, code, cont]),
		"overrideKey": version,
	}
}

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	operation := doc.paths[path].head

	response := operation.responses[code]

	cont := check_cont(response, version)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.responses.{{%s}}.%s", [path, code, cont]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.responses.{{%s}}.%s should not be defined", [path, code, cont]),
		"keyActualValue": sprintf("paths.{{%s}}.responses.{{%s}}.%s is defined", [path, code, cont]),
		"overrideKey": version,
	}
}

check_cont(response, version) = content {
	version == "3.0"
	common_lib.valid_key(response, "content")
	content := "content"
} else = content {
	version == "2.0"
	common_lib.valid_key(response, "schema")
	content := "schema"
}

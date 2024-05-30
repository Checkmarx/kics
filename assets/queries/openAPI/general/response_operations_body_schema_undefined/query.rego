package Cx

import data.generic.common as common_lib
import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	operation := doc.paths[p][op]
	response := operation.responses[code]
	acceptable_response(code, op)

	key := get_key_by_version(version)
	not common_lib.valid_key(response, key)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.%s.%s.responses.%s", [p, op, code]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("paths.%s.%s.responses.%s.%s should be defined", [p, op, code, key]),
		"keyActualValue": sprintf("paths.%s.%s.responses.%s.%s is undefined", [p, op, code, key]),
		"overrideKey": version,
	}
}

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version == "3.0"

	operation := doc.paths[path][op]
	response := operation.responses[code]
	acceptable_response(code, op)

	count(response.content) == 0

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content", [path, op, code]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content should have at least one content-type defined", [path, op, code]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content has no content-type defined", [path, op, code]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version == "3.0"

	operation := doc.paths[path][op]
	response := operation.responses[code]
	acceptable_response(code, op)

	responses := response.content[content_type]
	not common_lib.valid_key(responses, "schema")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content.{{%s}}", [path, op, code, content_type]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content.{{%s}}.schema should be defined", [path, op, code, content_type]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content.{{%s}}.schema is undefined", [path, op, code, content_type]),
	}
}

acceptable_response(code, op) {
	operation_should_have_content := ["get", "put", "post", "delete", "options", "patch", "trace"]
	common_lib.equalsOrInArray(operation_should_have_content, lower(op))

	response_code_should_not_have_content := ["204", "304"]

	not common_lib.equalsOrInArray(response_code_should_not_have_content, lower(code))
}

get_key_by_version(version) = key {
	keys := {
		"2.0": "schema",
		"3.0": "content",
	}

	key = keys[version]
}

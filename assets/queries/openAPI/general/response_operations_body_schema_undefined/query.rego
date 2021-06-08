package Cx

import data.generic.common as common_lib
import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	operation := doc.paths[p][op]
	acceptable_response(operation, op)

	response := operation.responses[code]
	key := get_key_by_version(version)
	object.get(response, key, "undefined") == "undefined"

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.%s.%s.responses.%s", [p, op, code]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("paths.%s.%s.responses.%s.%s is defined", [p, op, code, key]),
		"keyActualValue": sprintf("paths.%s.%s.responses.%s.%s is undefined", [p, op, code, key]),
		"overrideKey": version,
	}
}

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version == "3.0"

	operation := doc.paths[path][op]
	acceptable_response(operation, op)

	count(operation.responses[code].content) == 0

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
	acceptable_response(operation, op)

	response := operation.responses[code]
	object.get(response.content[content_type], "schema", "undefined") == "undefined"

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content.{{%s}}", [path, op, code, content_type]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content.{{%s}}.schema should be defined", [path, op, code, content_type]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content.{{%s}}.schema is undefined", [path, op, code, content_type]),
	}
}

acceptable_response(operation, op) {
	operation_should_have_content := ["get", "put", "post", "delete", "options", "patch", "trace"]
	common_lib.equalsOrInArray(operation_should_have_content, lower(op))

	response_code_should_not_have_content := ["204", "304"]

	response := operation.responses[code]
	not common_lib.equalsOrInArray(response_code_should_not_have_content, lower(code))
}

get_key_by_version(version) = key {
	keys := {
		"2.0": "schema",
		"3.0": "content",
	}

	key = keys[version]
}

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

	object.get(response, "content", "undefined") != "undefined"

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content", [path, op, code]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content is not defined", [path, op, code]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content is defined", [path, op, code]),
		"overrideKey": version,
	}
}

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	operation := doc.paths[path].head

	response := operation.responses[code]

	object.get(response, "content", "undefined") != "undefined"

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.responses.{{%s}}.content", [path, code]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.responses.{{%s}}.content is not defined", [path, code]),
		"keyActualValue": sprintf("paths.{{%s}}.responses.{{%s}}.content is defined", [path, code]),
		"overrideKey": version,
	}
}

# In version 2.0 responses object doesn't have 'content', has 'shcema'

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

	object.get(response, "schema", "undefined") != "undefined"

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.schema", [path, op, code]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.schema is not defined", [path, op, code]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.schema is defined", [path, op, code]),
		"overrideKey": version,
	}
}

# In version 2.0 responses object doesn't have 'content', has 'shcema'

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	operation := doc.paths[path].head

	response := operation.responses[code]

	object.get(response, "schema", "undefined") != "undefined"

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.responses.{{%s}}.schema", [path, code]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.responses.{{%s}}.schema is not defined", [path, code]),
		"keyActualValue": sprintf("paths.{{%s}}.responses.{{%s}}.schema is defined", [path, code]),
		"overrideKey": version,
	}
}

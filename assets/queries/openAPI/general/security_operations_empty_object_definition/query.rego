package Cx

import data.generic.openapi as openapi_lib
import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	operationObject := doc.paths[path][operation]
	common_lib.valid_key(operationObject, "security")

	not is_array(operationObject.security)
	operationObject.security == {}

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.security", [path, operation]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Security operation field should not be empty object",
		"keyActualValue": "Security operation field is an empty object",
		"overrideKey": version,
	}
}

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	operationObject := doc.paths[path][operation]
	common_lib.valid_key(operationObject, "security")

	is_array(operationObject.security)
	operationSecurityObject := operationObject.security[_]
	operationSecurityObject == {}

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.security", [path, operation]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Security operation field array should not have an empty object",
		"keyActualValue": "Security operation field array has an empty object",
		"overrideKey": version,
	}
}

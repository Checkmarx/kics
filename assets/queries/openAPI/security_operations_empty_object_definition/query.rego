package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	operationObject := doc.paths[path][operation]
	object.get(operationObject, "security", "undefined") != "undefined"

	not is_array(operationObject.security)
	operationObject.security == {}

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.security", [path, operation]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Security operation field should not be empty object",
		"keyActualValue": "Security operation field is an empty object",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	operationObject := doc.paths[path][operation]
	object.get(operationObject, "security", "undefined") != "undefined"

	is_array(operationObject.security)
	operationSecurityObject := operationObject.security[_]
	operationSecurityObject == {}

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.security", [path, operation]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Security operation field array should not have an empty object",
		"keyActualValue": "Security operation field array has an empty object",
	}
}

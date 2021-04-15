package Cx

import data.generic.openapi as openAPILib

CxPolicy[result] {
	doc := input.document[i]
	openAPILib.check_openapi(doc) != "undefined"

	operationObject := doc.paths[path][operation]
	object.get(operationObject, "security", "undefined") != "undefined"

	not is_array(operationObject.security)
	operationObject.security == {}

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.security", [path, operation]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Security operation field array, when declared, should not be empty",
		"keyActualValue": "Security operation field array is declared and empty",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openAPILib.check_openapi(doc) != "undefined"

	operationObject := doc.paths[path][operation]
	object.get(operationObject, "security", "undefined") != "undefined"

	is_array(operationObject.security)
	operationSecurityObject := operationObject.security[_]
	operationSecurityObject == {}

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.security", [path, operation]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Security operation field array, when declared, should not be empty",
		"keyActualValue": "Security operation field array is declared and empty",
	}
}

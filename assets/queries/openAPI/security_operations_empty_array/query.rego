package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	operationObject := doc.paths[path][operation]
	object.get(operationObject, "security", "undefined") != "undefined"

	is_array(operationObject.security)
	count(operationObject.security) == 0

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.security", [path, operation]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Security operation field array, when declared, should not be empty",
		"keyActualValue": "Security operation field array is declared and empty",
	}
}

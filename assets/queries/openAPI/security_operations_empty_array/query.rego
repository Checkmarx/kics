package Cx

import data.generic.openapi as openAPILib

CxPolicy[result] {
	doc := input.document[i]
	openAPILib.checkOpenAPI(doc) != "undefined"

	operationObject := doc.paths[path][operation]
	object.get(operationObject, "security", "undefined") != "undefined"
	count(operationObject.security) == 0

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.security", [path, operation]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Security operation field array, when declared, should not be empty",
		"keyActualValue": "Security operation field array is declared and empty",
	}
}

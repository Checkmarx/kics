package Cx

import data.generic.openapi as openapi_lib
import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	operationObject := doc.paths[path][operation]
	common_lib.valid_key(operationObject, "security")

	is_array(operationObject.security)
	count(operationObject.security) == 0

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.security", [path, operation]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Security operation field array, when declared, should not be empty",
		"keyActualValue": "Security operation field array is declared and empty",
		"overrideKey": version,
	}
}

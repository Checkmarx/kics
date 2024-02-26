package Cx

import data.generic.openapi as openapi_lib
import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"
	not common_lib.valid_key(doc, "security")

	operationObject := doc.paths[path][operation]
	not common_lib.valid_key(operationObject, "security")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}", [path, operation]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "A security schema should be used",
		"keyActualValue": "No security schema is used",
		"overrideKey": version,
	}
}

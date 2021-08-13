package Cx

import data.generic.openapi as openapi_lib
import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"
	response := doc.paths[n][oper].responses

	not common_lib.valid_key(response, "default")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.responses", [n, oper]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Default field should be defined on responses",
		"keyActualValue": "Default field is not defined on responses",
		"overrideKey": version,
	}
}

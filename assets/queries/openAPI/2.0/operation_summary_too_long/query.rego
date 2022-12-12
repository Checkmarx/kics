package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	count(doc.paths[n][oper].summary) > 120

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.summary", [n, oper]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Operation summary should not be less than 120 characters",
		"keyActualValue": "Operation summary is less than 120 characters",
	}
}

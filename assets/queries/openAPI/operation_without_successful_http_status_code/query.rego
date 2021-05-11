package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	responses := doc.paths[n][oper].responses

	count({x | response := responses[x]; openapi_lib.content_allowed(oper, x); regex.match(`^20[0124]$`, x) == true}) == 0

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("openapi.paths.{{%s}}.{{%s}}.responses", [n, oper]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("openapi.paths.{{%s}}.{{%s}}.responses has at least one successful HTTP status code defined", [n, oper]),
		"keyActualValue": sprintf("openapi.paths.{{%s}}.{{%s}}.responses does not have at least one successful HTTP status code defined", [n, oper]),
	}
}

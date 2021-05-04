package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	p := doc.paths[path]
	operations := {"get", "post", "put", "delete", "options", "head", "patch", "trace"}

	count({x | element := p[x]; x == operations[_]}) == 0

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("openapi.paths.{{%s}}", [path]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("openapi.paths.{{%s}} has at least one operation object defined", [path]),
		"keyActualValue": sprintf("openapi.paths.{{%s}} does not have at least one operation object defined", [path]),
	}
}

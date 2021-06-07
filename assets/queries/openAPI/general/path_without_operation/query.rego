package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	p := doc.paths[path]
	operations := {"get", "post", "put", "delete", "options", "head", "patch", "trace"}

	count({x | element := p[x]; x == operations[_]}) == 0

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}", [path]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("paths.{{%s}} has at least one operation object defined", [path]),
		"keyActualValue": sprintf("paths.{{%s}} does not have at least one operation object defined", [path]),
		"overrideKey": version,
	}
}

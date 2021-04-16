package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	paths := doc.paths[path][oper].servers[n]

	regex.match("^(http:)", paths.url)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("openapi.paths.{{%s}}.{{%s}}.servers.url={{%s}}", [path, oper, paths.url]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Path Server Object url uses 'HTTPS' protocol",
		"keyActualValue": "Path Server Object url uses 'HTTP' protocol",
	}
}

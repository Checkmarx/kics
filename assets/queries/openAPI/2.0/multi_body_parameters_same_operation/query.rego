package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	op := doc.paths[path][operation]
	bodyParameters := [p | p := op.parameters[_]; p.in == "body"]
	count(bodyParameters) > 1

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.%s.parameters", [path, operation]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Operation's parameters should have just one body type parameter",
		"keyActualValue": "Operation's parameters has more than one body type parameter",
	}
}

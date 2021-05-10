package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	doc.components.headers[header]
	headerRef := sprintf("#/components/headers/%s", [header])

	count({headerRef | [_, value] := walk(doc); headerRef == value["$ref"]}) == 0
	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.headers.{{%s}}", [header]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "header should be used as reference somewhere",
		"keyActualValue": "header is not used as reference",
	}
}

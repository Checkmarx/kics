package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	params := doc.responses[name]
	[path, value] := walk(doc)
	ref := value["$ref"]
	count({x | ref == sprintf("#/responses/%s", [name]); x := ref}) == 0

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("responses.{{%s}}", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("responses definition '%s' is used", [name]),
		"keyActualValue": sprintf("responses definition '%s' is not being used", [name]),
	}
}

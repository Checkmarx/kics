package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	[path, value] := walk(doc)

	value.content[c]
	not openapi_lib.is_mimetype_valid(c)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.content.{{%s}}", [openapi_lib.concat_path(path), c]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s.content.{{%s}} is a known prefix", [openapi_lib.concat_path(path), c]),
		"keyActualValue": sprintf("%s.content.{{%s}} is an unknown prefix", [openapi_lib.concat_path(path), c]),
	}
}

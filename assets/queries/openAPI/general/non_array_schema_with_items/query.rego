package Cx

import data.generic.openapi as openapi_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	[path, value] := walk(doc)

	value.type != "array"
	value.items

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.items", [openapi_lib.concat_path(path)]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Schema items property should be undefined",
		"keyActualValue": "Schema items property is defined",
		"overrideKey": version,
	}
}

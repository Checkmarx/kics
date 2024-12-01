package Cx

import data.generic.openapi as openapi_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	[path, value] := walk(doc)

	value.type == "array"
	not value.items

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s", [openapi_lib.concat_path(path)]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Array items property should be defined",
		"keyActualValue": "Array items property is undefined",
		"overrideKey": version,
	}
}

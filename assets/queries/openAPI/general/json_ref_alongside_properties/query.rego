package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	[path, value] := walk(doc)
	object.get(value, "$ref", "undefined") != "undefined"

	count(object.remove(value, ["_kics_lines"])) > 1

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s", [openapi_lib.concat_path(path)]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Only '$ref' property declared or other properties declared without '$ref'",
		"keyActualValue": "Property '$ref'alongside other properties",
		"overrideKey": version,
	}
}

package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	[path, value] := walk(doc)
	value.type == "string"
	broad_schema(value.pattern)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.pattern", [openapi_lib.concat_path(path)]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "String schema has 'pattern' restricted",
		"keyActualValue": "String schema does not have 'pattern' restricted",
		"overrideKey": version,
	}
}

broad_schema(pattern) {
	startswith(pattern, "^") == false
} else {
	endswith(pattern, "$") == false
}

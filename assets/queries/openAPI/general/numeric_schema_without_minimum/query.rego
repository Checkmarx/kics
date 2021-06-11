package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	[path, value] := walk(doc)

	openapi_lib.undefined_field_in_numeric_schema(value, "minimum")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.type", [openapi_lib.concat_path(path)]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Numeric schema has 'minimum' defined",
		"keyActualValue": "Numeric schema does not have 'minimum' defined",
		"overrideKey": version,
	}
}

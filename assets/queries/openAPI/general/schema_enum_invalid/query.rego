package Cx

import data.generic.common as commonLib
import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	[path, value] := walk(doc)

	openapi_lib.invalid_field(value.enum[x], value.type)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.enum", [openapi_lib.concat_path(path)]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The field 'enum' should be consistent with the schema's type",
		"keyActualValue": "The field 'enum' is not consistent with the schema's type",
		"overrideKey": version,
		"searchLine": commonLib.build_search_line(path, ["enum", x]),
	}
}

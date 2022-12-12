package Cx

import data.generic.openapi as openapi_lib
import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	[path, value] := walk(doc)
	value.type == "object"
	prop := value.required[_]
	common_lib.valid_key(value.properties[prop], "default")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.properties.{{%s}}.default", [openapi_lib.concat_path(path), prop]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Required properties should not have default defined",
		"keyActualValue": "Required properties with default defined",
		"overrideKey": version,
	}
}

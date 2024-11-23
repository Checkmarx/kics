package Cx

import data.generic.common as common_lib
import data.generic.openapi as openapi_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	[path, value] := walk(doc)
	value.type == "object"
	some prop in value.required
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

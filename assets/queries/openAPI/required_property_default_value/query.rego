package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	[path, value] := walk(doc)
	value.type == "object"
	prop := value.required[_]
	object.get(value.properties[prop], "default", "undefined") != "undefined"

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.properties.{{%s}}.default", [openapi_lib.concat_path(path), prop]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Required properties does not have default defined",
		"keyActualValue": "Required properties with default defined",
	}
}

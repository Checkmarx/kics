package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	[path, value] := walk(doc)
	value.type == "array"
	items := value.items
	not items.type
	not is_oneOf_valid(items)
	not items["$ref"]

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.items", [openapi_lib.concat_path(path)]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s.items have type, anyOf.type, $ref or anyOf.$ref is defined", [openapi_lib.concat_path(path)]),
		"keyActualValue": sprintf("%s.items have type, anyOf.type, $ref or anyOf.$ref is undefined", [openapi_lib.concat_path(path)]),
	}
}

is_oneOf_valid(items) {
	object.get(items, "oneOf", "undefined") != "undefined"
	is_array(items.oneOf)
	count(items.oneOf) > 0
	count({item | item := items.oneOf[_]; object.get(item, "type", "undefined") == "undefined"; object.get(item, "$ref", "undefined") == "undefined"}) == 0
}

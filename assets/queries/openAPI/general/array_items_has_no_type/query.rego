package Cx

import data.generic.openapi as openapi_lib
import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

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
		"keyExpectedValue": sprintf("%s.items should have type, anyOf.type, $ref or anyOf.$ref should be defined", [openapi_lib.concat_path(path)]),
		"keyActualValue": sprintf("%s.items have type, anyOf.type, $ref or anyOf.$ref is undefined", [openapi_lib.concat_path(path)]),
		"overrideKey": version,
	}
}

is_oneOf_valid(items) {
	common_lib.valid_key(items, "oneOf")
	is_array(items.oneOf)
	count(items.oneOf) > 0
	count({item | item := items.oneOf[_]; not common_lib.valid_key(item, "type"); not common_lib.valid_key(item, "$ref")}) == 0
}

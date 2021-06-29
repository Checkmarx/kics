package Cx

import data.generic.openapi as openapi_lib

#This rules verifies anyOf and oneOf
CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	[path, value] := walk(doc)
	multiSchemas := get_schema_list(value)
	schema := multiSchemas.schemas[_]
	check_schema_type(schema.type)
	schema.additionalProperties == "false"
	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.%s", [openapi_lib.concat_path(path), multiSchemas.kind]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'additionalProperties' is not false",
		"keyActualValue": "'additionalProperties' is false",
	}
}

#This rules verifies allOf
CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	[path, value] := walk(doc)
	multiSchemas := value.allOf
	schema := multiSchemas[_]
	schema.additionalProperties == "false"
	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.allOf", [openapi_lib.concat_path(path)]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'additionalProperties' is not false",
		"keyActualValue": "'additionalProperties' is false",
	}
}

check_schema_type(type) {
	type == "object"
} else {
	type == "array"
}

get_schema_list(value) = result {
	object.get(value, "anyOf", "undefined") != "undefined"
	result := {"schemas": value.anyOf, "kind": "anyOf"}
} else = result {
	object.get(value, "oneOf", "undefined") != "undefined"
	result := {"schemas": value.oneOf, "kind": "oneOf"}
}

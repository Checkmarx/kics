package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	[path, value] := walk(doc)

	invalid_default_field(value["default"], value.type)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.default", [openapi_lib.concat_path(path)]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The field 'default' is consistent with the schema's type",
		"keyActualValue": "The field 'default' is not consistent with the schema's type",
	}
}

invalid_default_field(default_field, type) {
	numeric := {"integer", "number"}
	type == numeric[_]
	not is_number(default_field)
} else {
	type == "string"
	not is_string(default_field)
} else {
	type == "boolean"
	not is_boolean(default_field)
} else {
	type == "object"
	not is_object(default_field)
} else {
	type == "array"
	not is_array(default_field)
}

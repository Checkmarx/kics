package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"
	keywords := {
		"numeric": {"minimum", "maximum", "exclusiveMaximum", "exclusiveMinimum", "multipleOf"},
		"string": {"minLength", "maxLength", "pattern"},
	}

	[path, value] := walk(doc)
	type := get_type(value.type)
	value.enum
	count(value.enum) > 0
	value[keyword]
	keyword == keywords[type][_]

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.%s", [openapi_lib.concat_path(path), keyword]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Type %s should not have enum and constraining keywords", [type]),
		"keyActualValue": sprintf("Type %s has enum and %s", [type, keyword]),
	}
}

get_type(type) = result {
	openapi_lib.is_numeric_type(type)
	result := "numeric"
} else = result {
	type == "string"
	result := "string"
}

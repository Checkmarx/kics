package Cx

import data.generic.common as common_lib
import data.generic.openapi as openapi_lib

specificKeywords := {
	"numeric": ["multipleOf", "maximum", "minimum", "exclusiveMaximum", "exclusiveMinimum"],
	"string": ["pattern", "minLength", "maxLength"],
	"array": ["maxItems", "minItems", "uniqueItems", "items"],
	"object": ["required", "maxProperties", "minProperties"],
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	[path, value] := walk(doc)
	object.get(value, "type", "undefined") != "undefined"
	invalidKey := check_keywords(value)
	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.%s", [openapi_lib.concat_path(path), invalidKey]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "There isn't any invalid keywords",
		"keyActualValue": sprintf("Keyword %s is not valid for type %s", [invalidKey, value.type]),
	}
}

check_keywords(value) = name {
	keywords := specificKeywords[type]
	typeName := get_value_type(value.type)
	type != typeName
	value[key]
	common_lib.inArray(keywords, key)
	name := key
}

get_value_type(type) = typeName {
	openapi_lib.is_numeric_type(type)
	typeName := "numeric"
} else = typeName {
	typeName := type
}

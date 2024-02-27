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
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	[path, value] := walk(doc)
	common_lib.valid_key(value, "type")
	invalidKeys := check_keywords(value)
	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.%s", [openapi_lib.concat_path(path), invalidKeys[a]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "There shouldn't be any invalid keywords",
		"keyActualValue": sprintf("Keyword %s is not valid for type %s", [invalidKeys[a], value.type]),
		"overrideKey": version,
	}
}

check_keywords(value) = invalidKeys {
	invalidKeys := { invalidKeyword |
        keywords := specificKeywords[type]
		typeName := get_value_type(value.type)
		type != typeName
		value[key]
		common_lib.inArray(keywords, key)
		invalidKeyword := key
    }
}

get_value_type(type) = typeName {
	openapi_lib.is_numeric_type(type)
	typeName := "numeric"
} else = typeName {
	typeName := type
}


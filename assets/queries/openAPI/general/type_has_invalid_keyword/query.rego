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
	invalidKeys := { invalidKeyword |
        keywords := specificKeywords[value.type]
		value[key]
        not common_lib.inArray(keywords, key)
        invalidKeyword := key
    }
	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.%s", [openapi_lib.concat_path(path), invalidKeys[_]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "There shouldn't be any invalid keywords",
		"keyActualValue": sprintf("Keyword %s is not valid for type %s", [invalidKeys[_], value.type]),
		"overrideKey": version,
	}
}


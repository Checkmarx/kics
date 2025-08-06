package Cx

import data.generic.openapi as openapi_lib
import data.generic.common as common_lib

CxPolicy[result] {
	keywords := ["multipleOf", "maximum", "minimum", "exclusiveMaximum", "exclusiveMinimum", "pattern", "minLength", "maxLength", "maxItems", "minItems", "uniqueItems", "required", "maxProperties", "minProperties"]

	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	[path, value] := walk(doc)
	properties := value.properties[name]
	common_lib.valid_key(properties, "enum")
	common_lib.valid_key(properties, keywords[x])

	path_c := {x | obj := clean_path(path[n]); obj != ""; x := obj}

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.%s", [openapi_lib.concat_path(path), name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s.properties.%s should not contain 'enum' and schema keyword", [concat(".", path_c), name]),
		"keyActualValue": sprintf("%s.properties.%s contains 'enum' and schema keyword '%s'", [concat(".", path_c), name, keywords[x]]),
		"overrideKey": version,
	}
}

clean_path(path) = cleaned_path {
	is_number(path)
	cleaned_path := ""
} else = cleaned_path {
	cleaned_path := path
}

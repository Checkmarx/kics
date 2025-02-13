package Cx

import data.generic.openapi as openapi_lib
import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	[path, value] := walk(doc)
	info := openapi_lib.is_operation(path)
	openapi_lib.content_allowed(info.operation, info.code)
	openapi_lib.undefined_field_in_string_type(value, "maxLength")
    checkForSecureStringFormats(value)
	not limited_regex(value)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.type", [openapi_lib.concat_path(path)]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'maxLength' should be defined",
		"keyActualValue": "'maxLength' is undefined",
		"overrideKey": version,
		"searchLine": common_lib.build_search_line(path,["type"]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	[path, value] := walk(doc)
	openapi_lib.is_operation(path) == {}
	openapi_lib.undefined_field_in_string_type(value, "maxLength")
	checkForSecureStringFormats(value)
	not limited_regex(value)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.type", [openapi_lib.concat_path(path)]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'maxLength' should be defined",
		"keyActualValue": "'maxLength' is undefined",
		"overrideKey": version,
		"searchLine": common_lib.build_search_line(path,["type"]),
	}
}

limited_regex(value){
	not contains(value.pattern, "+")
	not contains(value.pattern, "*")
	not regex.match("[^\\\\]{\\d+,}", value.pattern)
}

checkForSecureStringFormats(value) {
	openapi_lib.undefined_field_in_string_type(value, "enum")   # enums have the maxLength implicit
	checkStringFormat(value)
}

checkStringFormat(value) {
    openapi_lib.undefined_field_in_string_type(value, "format")
} else {
    value["format"] != "date"       # date and date-time formats
    value["format"] != "date-time"  # have the maxLength implicit
}

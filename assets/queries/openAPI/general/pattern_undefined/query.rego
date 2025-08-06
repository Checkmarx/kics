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
	openapi_lib.undefined_field_in_string_type(value, "pattern")
	checkForSecureStringFormats(value)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.type", [openapi_lib.concat_path(path)]),
		"searchLine": common_lib.build_search_line(path, ["type"]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'pattern' should be defined",
		"keyActualValue": "'pattern' is undefined",
		"overrideKey": version,
	}
}

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	[path, value] := walk(doc)
	openapi_lib.is_operation(path) == {}
	openapi_lib.undefined_field_in_string_type(value, "pattern")
	checkForSecureStringFormats(value)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.type", [openapi_lib.concat_path(path)]),
		"searchLine": common_lib.build_search_line(path, ["type"]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'pattern' should be defined",
		"keyActualValue": "'pattern' is undefined",
		"overrideKey": version,
	}
}

checkForSecureStringFormats(value) {
	openapi_lib.undefined_field_in_string_type(value, "enum")   # enums have an implicit pattern
	checkStringFormat(value)
}

checkStringFormat(value) {
    openapi_lib.undefined_field_in_string_type(value, "format")
} else {
    value["format"] != "date"       # date and date-time formats
    value["format"] != "date-time"  # have an implicit pattern
}

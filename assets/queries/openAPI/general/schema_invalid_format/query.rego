package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	[path, value] := walk(doc)
	format := value.format
	is_format_valid(value.type, format)
	correctTypes := {
		"number": "float or double",
		"integer": "int32 or int64",
		"string": "binary, byte,date, date-time, or password",
	}

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.format", [openapi_lib.concat_path(path)]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s is %s formats", [value.type, correctTypes[value.type]]),
		"keyActualValue": sprintf("%s is %s format", [value.type, format]),
		"overrideKey": version,
	}
}

is_format_valid(type, format) {
	type == "number"
	validFormats := {"float", "double"}
	count({format} - validFormats) > 0
} else {
	type == "integer"
	validFormats := {"int32", "int64"}
	count({format} - validFormats) > 0
} else {
	type == "string"
	validFormats := {"binary", "byte", "date", "date-time", "password"}
	count({format} - validFormats) > 0
}

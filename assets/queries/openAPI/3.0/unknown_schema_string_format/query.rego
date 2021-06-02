package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	[path, value] := walk(doc)

	value.type == "string"
	not known_format(value.format)

	formats := "'date', 'date-time', 'password', 'byte', 'binary', 'email', 'uuid', 'uri', 'hostname', 'ipv4' or 'ipv6'"

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.format", [openapi_lib.concat_path(path)]),
		"issueType": "IncorrectValue",
		"keyActualValue": sprintf("String schema has 'format' set as %s", [formats]),
		"keyExpectedValue": sprintf("String schema does not have 'format' set as %s", [formats]),
	}
}

known_format(format) {
	known_formats := {"date", "date-time", "password", "byte", "binary", "email", "uuid", "uri", "hostname", "ipv4", "ipv6"}
	format == known_formats[x]
}

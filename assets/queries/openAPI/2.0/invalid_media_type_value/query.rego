package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	[path, value] := walk(doc)

	fields := {"consumes", "produces"}
	mime := value[fields[field]][idx]

	type := "[A-Za-z0-9][A-Za-z0-9!#$&\\-^_]{0,126}"
	subtype := "[A-Za-z0-9][A-Za-z0-9!#$&\\-^_.+]{0,126}"
	token := "([!#$%&'*+.^_`|~0-9A-Za-z-]+)"
	space := "[ \t]*"
	quotedString := "\"(?:[^\"\\\\]|\\.)*\""
	parameter := concat("", [";", space, token, space, "=", space, "(", token, "|", quotedString, ")"])

	mimeRegex := concat("", ["^", type, "/", "(", subtype, ")", "(", parameter, ")*", "$"])

	regex.match(mimeRegex, mime) == false

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.%s.%s", [openapi_lib.concat_path(path), field, mime]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The Media Type is a valid value",
		"keyActualValue": "The Media Type is a invalid value",
	}
}

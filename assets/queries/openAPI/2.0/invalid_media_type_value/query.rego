package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	[path, value] := walk(doc)

	fields := {"consumes", "produces"}
	mime := value[fields[field]][idx]

	not openapi_lib.is_valid_mime(mime)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.%s.%s", [openapi_lib.concat_path(path), field, mime]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The Media Type should be a valid value",
		"keyActualValue": "The Media Type is a invalid value",
	}
}

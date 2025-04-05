package Cx

import data.generic.openapi as openapi_lib
import future.keywords.in

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	[path, value] := walk(doc)
	count(path) > 0

	"http" in value.schemes

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.schemes.http", [openapi_lib.concat_path(path)]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The Scheme list uses only 'HTTPS' protocol",
		"keyActualValue": "The Scheme list uses 'HTTP' protocol",
	}
}

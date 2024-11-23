package Cx

import data.generic.openapi as openapi_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	openapi_lib.check_openapi(doc) == "2.0"

	[path, value] := walk(doc)

	some c in value.produces
	not openapi_lib.is_mimetype_valid(c)
	sk := search_key(path)

	result := {
		"documentId": doc.id,
		"searchKey": sk,
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s has only known prefixes", [sk]),
		"keyActualValue": sprintf("%s on '%s' is an unknown prefix", [c, sk]),
	}
}

search_key(path) = searchKey {
	count(path) > 0
	searchKey := sprintf("%s.produces", [openapi_lib.concat_path(path)])
} else = searchKey {
	searchKey := "produces"
}

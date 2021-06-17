package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	[path, value] := walk(doc)

	c := value.produces[_]
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

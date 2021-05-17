package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	[path, value] := walk(doc)

	ref := value.links[l]["$ref"]
	openapi_lib.incorrect_ref(ref, "links")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.links.$ref", [openapi_lib.concat_path(path)]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Link ref points to '#/components/links'",
		"keyActualValue": "Link ref does not point to '#/components/links'",
	}
}

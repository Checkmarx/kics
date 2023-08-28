package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	[path, value] := walk(doc)

	ref := value.links[l]["RefMetadata"]["$ref"]
	path[minus(count(path), 1)] != "components"
	openapi_lib.incorrect_ref(ref, "links")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.links.{{%s}}.$ref", [openapi_lib.concat_path(path), l]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Link ref points to '#/components/links'",
		"keyActualValue": "Link ref does not point to '#/components/links'",
	}
}

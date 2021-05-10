package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	doc.components.links[link]
	linkRef := sprintf("#/components/links/%s", [link])

	count({linkRef | [_, value] := walk(doc); linkRef == value["$ref"]}) == 0
	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.links.{{%s}}", [link]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Link should be used as reference somewhere",
		"keyActualValue": "Link is not used as reference",
	}
}

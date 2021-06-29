package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	doc.components.links[link]
	openapi_lib.check_unused_reference(doc, link, "links")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.links.{{%s}}", [link]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Link should be used as reference somewhere",
		"keyActualValue": "Link is not used as reference",
	}
}

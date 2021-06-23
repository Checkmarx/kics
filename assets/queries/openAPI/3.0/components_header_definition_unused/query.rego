package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	doc.components.headers[header]
	openapi_lib.check_unused_reference(doc, header, "headers")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.headers.{{%s}}", [header]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Header should be used as reference somewhere",
		"keyActualValue": "Header is not used as reference",
	}
}

package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	doc.components.headers[header]
	openapi_lib.check_reference_exists(doc, header, "headers")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.headers.{{%s}}", [header]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Header should be used as reference somewhere",
		"keyActualValue": "Header is not used as reference",
	}
}

package Cx

import data.generic.openapi as openapi_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	openapi_lib.check_openapi(doc) == "3.0"

	doc.components.examples[example]
	openapi_lib.check_unused_reference(doc, example, "examples")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.examples.{{%s}}", [example]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Example should be used as reference somewhere",
		"keyActualValue": "Example is not used as reference",
	}
}

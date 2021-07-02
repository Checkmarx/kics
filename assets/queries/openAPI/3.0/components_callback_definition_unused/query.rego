package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	doc.components.callbacks[callback]
	openapi_lib.check_unused_reference(doc, callback, "callbacks")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.callbacks.{{%s}}", [callback]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Callback should be used as reference somewhere",
		"keyActualValue": "Callback is not used as reference",
	}
}

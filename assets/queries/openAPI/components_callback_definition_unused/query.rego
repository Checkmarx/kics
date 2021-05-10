package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	doc.components.callbacks[callback]
	callbackRef := sprintf("#/components/callbacks/%s", [callback])

	count({callbackRef | [_, value] := walk(doc); callbackRef == value["$ref"]}) == 0
	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.callbacks.{{%s}}", [callback]),
		"t": callbackRef,
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Callback should be used as reference somewhere",
		"keyActualValue": "Callback is not used as reference",
	}
}

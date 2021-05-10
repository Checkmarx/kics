package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	doc.components.examples[example]
	exampleRef := sprintf("#/components/examples/%s", [example])

	count({exampleRef | [_, value] := walk(doc); exampleRef == value["$ref"]}) == 0
	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.examples.{{%s}}", [example]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "example should be used as reference somewhere",
		"keyActualValue": "example is not used as reference",
	}
}

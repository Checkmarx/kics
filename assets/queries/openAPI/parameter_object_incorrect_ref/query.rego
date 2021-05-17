package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	[path, value] := walk(doc)

	ref := value.parameters[n]["$ref"]
	openapi_lib.incorrect_ref(ref, "parameters")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.parameters.$ref", [openapi_lib.concat_path(path)]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Parameter Object ref points to '#/components/parameters'",
		"keyActualValue": "Parameter Object ref doesn't point to '#/components/parameters'",
	}
}

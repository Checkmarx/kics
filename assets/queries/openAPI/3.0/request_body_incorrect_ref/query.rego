package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	[path, value] := walk(doc)

	ref := value.requestBody["RefMetadata"]["$ref"]
	openapi_lib.incorrect_ref(ref, "requestBodies")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.requestBody.$ref", [openapi_lib.concat_path(path)]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Request body ref points to '#/components/requestBodies'",
		"keyActualValue": "Request body ref doesn't point to '#/components/requestBodies'",
	}
}

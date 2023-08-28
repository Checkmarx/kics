package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	[path, value] := walk(doc)

	ref := value.responses[code]["RefMetadata"]["$ref"]
	path[minus(count(path), 1)] != "components"
	openapi_lib.incorrect_ref(ref, "responses")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.responses.{{%s}}.$ref", [openapi_lib.concat_path(path), code]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Response ref points to '#/components/responses'",
		"keyActualValue": "Response ref does not point to '#/components/responses'",
	}
}

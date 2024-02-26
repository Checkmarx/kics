package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	[path, value] := walk(doc)
	ref := value.responses[code]["RefMetadata"]["$ref"]
	count(path) > 0
	openapi_lib.incorrect_ref_swagger(ref, "responses")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.responses.{{%s}}.$ref", [openapi_lib.concat_path(path), code]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Response ref points to '#/responses'",
		"keyActualValue": "Response ref doesn't point to '#/responses'",
	}
}

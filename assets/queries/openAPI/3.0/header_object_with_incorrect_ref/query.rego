package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	[path, value] := walk(doc)

	ref := value.headers[h]["RefMetadata"]["$ref"]
	path[minus(count(path), 1)] != "components"
	openapi_lib.incorrect_ref(ref, "headers")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.headers.{{%s}}.$ref", [openapi_lib.concat_path(path), h]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Response ref points to '#/components/headers'",
		"keyActualValue": "Response ref does not point to '#/components/headers'",
	}
}

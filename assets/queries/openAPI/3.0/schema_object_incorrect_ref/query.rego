package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	[path, value] := walk(doc)

	ref := value.schema["RefMetadata"]["$ref"]
	openapi_lib.incorrect_ref(ref, "schemas")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.schema.$ref", [openapi_lib.concat_path(path)]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Schema reference points to '#components/schemas'",
		"keyActualValue": "Schema reference does not point to '#components/schemas'",
	}
}

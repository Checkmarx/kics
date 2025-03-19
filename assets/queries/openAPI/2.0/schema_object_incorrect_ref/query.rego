package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	[path, value] := walk(doc)
	count(path) > 0

	ref := value.schema.RefMetadata["$ref"]
	openapi_lib.incorrect_ref_swagger(ref, "schemas")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.schema.$ref", [openapi_lib.concat_path(path)]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Schema ref points to '#/definitions'",
		"keyActualValue": "Schema ref doesn't point to '#/definitions'",
	}
}

package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	[path, value] := walk(doc)
	ref := value.parameters[n]["RefMetadata"]["$ref"]
	count(path) > 0
	openapi_lib.incorrect_ref_swagger(ref, "parameters")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.parameters.$ref=%s", [openapi_lib.concat_path(path), ref]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Parameters ref points to '#/parameters'",
		"keyActualValue": "Parameters ref doesn't point to '#/parameters'",
	}
}

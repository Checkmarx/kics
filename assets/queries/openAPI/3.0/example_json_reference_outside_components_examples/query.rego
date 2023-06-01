package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	[path, value] := walk(doc)
	ref := value["RefMetadata"]["$ref"]
	contains(path[j], "examples")
	not contains(path[minus(j, 1)], "components")
	openapi_lib.incorrect_ref(ref, "examples")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.$ref", [openapi_lib.concat_path(path)]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s should be declared on components.schemas", [ref]),
		"keyActualValue": sprintf("%s is not declared on components.schemas", [ref]),
	}
}

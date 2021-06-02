package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	[path, value] := walk(doc)
	ref := value["$ref"]
	checkComponents := openapi_lib.check_reference_unexisting(doc, ref, "headers")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.$ref", [openapi_lib.concat_path(path)]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s from %s is declared on components.headers", [checkComponents, ref]),
		"keyActualValue": sprintf("%s from %s is not declared on components.headers", [checkComponents, ref]),
	}
}

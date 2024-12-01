package Cx

import data.generic.openapi as openapi_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	openapi_lib.check_openapi(doc) == "2.0"

	[path, value] := walk(doc)
	ref := value["$ref"]
	checkComponents := openapi_lib.check_reference_unexisting_swagger(doc, ref, "responses")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.$ref", [openapi_lib.concat_path(path)]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s from %s should be declared on responses", [checkComponents, ref]),
		"keyActualValue": sprintf("%s from %s is not declared on responses", [checkComponents, ref]),
	}
}

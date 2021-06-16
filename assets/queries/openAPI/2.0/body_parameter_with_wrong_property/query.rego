package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	[path, value] := walk(doc)
	param := value.parameters[n]
	param.in == "body"

	property := param[x]
	not allowed(x)

	partialSk := openapi_lib.concat_default_value(openapi_lib.concat_path(path), "parameters")
	sk := openapi_lib.get_complete_search_key(n, partialSk, x)

	result := {
		"documentId": doc.id,
		"searchKey": sk,
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s is a valid property for body parameter", [property]),
		"keyActualValue": sprintf("%s is not a valid property for body parameter", [property]),
	}
}

allowed(property) {
	allowed := ["name", "in", "description", "required", "schema"]
	property == allowed[y]
}

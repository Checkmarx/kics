package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	[path, value] := walk(doc)
	params := value.parameters[n]
	openapi_lib.improperly_defined(params, "Authorization")

	p := openapi_lib.concat_path(path)
	parcialSk := openapi_lib.concat_default_value(p, "parameters")
	name := openapi_lib.get_name(p, params.name)

	sk := openapi_lib.get_complete_search_key(n, parcialSk, name)

	result := {
		"documentId": doc.id,
		"searchKey": sk,
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s should not be 'Authorization", [sk]),
		"keyActualValue": sprintf("%s is 'Authorization'", [sk]),
		"overrideKey": version,
	}
}

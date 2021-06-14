package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	[path, value] := walk(doc)
	params := value.parameters[n]
	openapi_lib.improperly_defined(params, "Accept")

	p := openapi_lib.concat_path(path)
	searchKey := openapi_lib.concat_default_value(p, "parameters")
	name := openapi_lib.get_name(p, params.name)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.%s", [searchKey, name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s.name={{%s}} is not 'Accept'", [searchKey, params.name]),
		"keyActualValue": sprintf("%s.name={{%s}} is 'Accept'", [searchKey, params.name]),
		"overrideKey": version,
	}
}

package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	[path, value] := walk(doc)
	params := value.parameters[n]

	openapi_lib.improperly_defined(params, "Accept")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.parameters.name={{%s}}", [openapi_lib.concat_path(path), params.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s.parameters.name={{%s}} is not 'Accept'", [openapi_lib.concat_path(path), params.name]),
		"keyActualValue": sprintf("%s.parameters.name={{%s}} is 'Accept'", [openapi_lib.concat_path(path), params.name]),
		"overrideKey": version,
	}
}

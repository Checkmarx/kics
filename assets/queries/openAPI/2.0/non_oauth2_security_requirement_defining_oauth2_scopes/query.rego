package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	[path, value] := walk(doc)
	sec := value.security[idx][name]
	count(sec) != 0

	type := doc.securityDefinitions[name].type
	type != "oauth"

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.%s", [openapi_lib.concat_default_value(openapi_lib.concat_path(path), "security"), name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("security scheme %s should specify scopes for type '%s'", [name, type]),
		"keyActualValue": sprintf("security scheme %s doesn't specify scopes for type '%s'", [name, type]),
	}
}

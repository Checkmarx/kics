package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"
	[path, value] := walk(doc)
	sec := value.security[idx][name]
	count(sec) > 0
	type := doc.components.securitySchemes[name].type
	auth_no_scopes := {"apiKey", "http"}
	type == auth_no_scopes[t]

	path_t = array.concat(path, ["security", name])

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s", [openapi_lib.concat_path(path_t)]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'security.%s' has no scopes defined for security scheme of type '%s'", [name, auth_no_scopes[t]]),
		"keyActualValue": sprintf("'security.%s' has no scopes defined for security scheme of type '%s'", [name, auth_no_scopes[t]]),
	}
}

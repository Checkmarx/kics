package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	[path, value] := walk(doc)
	sec := value.security[name]

	object.get(doc.securityDefinitions, name, "undefined") == "undefined"

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.%s", [openapi_lib.concat_default_value(openapi_lib.concat_path(path), "security"), name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s is defined in 'securityDefinitions'", [name]),
		"keyActualValue": sprintf("%s is not defined in 'securityDefinitions'", [name]),
	}
}

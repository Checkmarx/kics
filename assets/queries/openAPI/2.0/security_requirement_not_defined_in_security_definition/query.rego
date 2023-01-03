package Cx

import data.generic.openapi as openapi_lib
import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	[path, value] := walk(doc)
	sec := value.security[idx][name]

	not common_lib.valid_key(doc.securityDefinitions, name)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.%s", [openapi_lib.concat_default_value(openapi_lib.concat_path(path), "security"), name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s should be defined in 'securityDefinitions'", [name]),
		"keyActualValue": sprintf("%s is not defined in 'securityDefinitions'", [name]),
	}
}

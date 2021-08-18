package Cx

import data.generic.common as common_lib
import data.generic.openapi as openapi_lib

options := {null, {}}

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	[path, value] := walk(doc)

	# value.responses == options[x]
	common_lib.check_obj_empty(value.responses)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.responses", [openapi_lib.concat_path(path)]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'responses' is not empty",
		"keyActualValue": "'responses' is empty",
		"overrideKey": version,
	}
}

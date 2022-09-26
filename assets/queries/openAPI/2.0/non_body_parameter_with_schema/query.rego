package Cx

import data.generic.openapi as openapi_lib
import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	[path, value] := walk(doc)
	param := value.parameters[n]
	param.in != "body"
	common_lib.valid_key(param, "schema")

	searchKey := openapi_lib.concat_default_value(openapi_lib.concat_path(path), "parameters")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.name=%s.schema", [searchKey, param.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'schema' should not be set",
		"keyActualValue": "'schema' is set",
	}
}

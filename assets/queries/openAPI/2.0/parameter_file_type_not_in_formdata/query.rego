package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	[path, value] := walk(doc)
	param := value.parameters[n]
	param.type == "file"
	param.in != "formData"

	searchKey := openapi_lib.concat_default_value(openapi_lib.concat_path(path), "parameters")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.name=%s", [searchKey, param.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'schema' should be set",
		"keyActualValue": "'schema' is undefined",
	}
}
